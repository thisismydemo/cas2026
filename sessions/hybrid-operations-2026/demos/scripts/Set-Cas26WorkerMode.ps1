#Requires -Version 7.0
<#
.SYNOPSIS
    Change one IIC Hybrid Orders worker's CAS26 fault mode (Healthy, Delay, Fail or Pause).

.DESCRIPTION
    Implements the "Worker fault contract" and "Demo helper contract" in
    lab/design/HYBRID-APPLICATION-HEALTH-DESIGN.md. Both workers read /var/lib/cas26/worker-state.json on
    every message. This script writes only that CAS26-owned file:

      -SshTarget   on-premises worker (cas26-lnx01) over SSH       (Hybrid H16 reset)
      -InstanceId  AWS worker (EC2) over AWS Systems Manager Run Command (Observability M03)
      -StatePath   a local file, for local tests of a worker build

    Mode   FailureMode     Effect on demo-tagged orders only
    ----   -----------     ---------------------------------
    Healthy (empty)        normal processing (reset)
    Delay  deep-thought    adds DelaySeconds (default 8, maximum 30) before replying
    Fail   marvin          returns a deliberate failed stage result
    Pause  vogon           stops pulling from the queue (backlog, oldest-message age)

    Written file: {"project":"cas26","mode":...,"faultName":...,"delaySeconds":...,
    "expires_at":...,"updated_at":...,"previous":{"mode":...,"updated_at":...}}. A file with only
    "project" and "mode" (the form older runbooks write) stays valid for the worker.

    Safety rules:
      - A file that exists and does not carry "project":"cas26" is never changed.
      - Every non-Healthy mode carries expires_at (-MaxMinutes, default 15); after it the worker
        behaves as Healthy.
      - The previous state is read first, returned, and recorded in the "previous" key.
      - Idempotent: repeating a call produces the same mode; Changed reports whether the mode moved.
      - Healthy always succeeds when the file is missing (it creates a Healthy file).
      - Never stops a service, VM or host; never touches any other file.
      - -DryRun reads the current state (read-only) and shows the proposed file without writing.
    Exits non-zero on failure, so callers can use $LASTEXITCODE when run with pwsh -File.

.PARAMETER Mode
    Healthy, Delay, Fail or Pause.

.PARAMETER DelaySeconds
    Only with -Mode Delay. 1-30 seconds; default 8.

.PARAMETER MaxMinutes
    Fault lifetime written as expires_at (UTC). 1-60 minutes; default 15. Ignored for Healthy.

.PARAMETER SshTarget
    user@host of the on-premises worker.

.PARAMETER SshKeyPath
    Optional private key for -SshTarget (otherwise the SSH agent/default key).

.PARAMETER InstanceId
    EC2 instance ID of the AWS worker (i-...). Uses the AWS CLI and SSM Run Command.

.PARAMETER AwsRegion
    Optional AWS region for -InstanceId. Defaults to the AWS CLI configuration.

.PARAMETER AwsProfile
    Optional AWS CLI profile for -InstanceId.

.PARAMETER StatePath
    Local state file (tests only).

.PARAMETER DryRun
    Read the current state and print the proposed change without writing it.

.EXAMPLE
    pwsh ./sessions/<session>/demos/scripts/Set-Cas26WorkerMode.ps1 -Mode Fail -InstanceId i-0123456789abcdef0 -MaxMinutes 15 -DryRun

.EXAMPLE
    pwsh ./sessions/<session>/demos/scripts/Set-Cas26WorkerMode.ps1 -SshTarget $WorkerSshTarget -Mode Healthy

.NOTES
    Version: 2.0.0 (2026-09-26) - Delay/Pause modes, -InstanceId (SSM), -MaxMinutes expiry,
    previous-state record. 1.1.0 (2026-09-09) added -SshTarget and -DryRun.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidateSet('Healthy', 'Delay', 'Fail', 'Pause')][string]$Mode,
    [ValidateRange(1, 30)][int]$DelaySeconds = 8,
    [ValidateRange(1, 60)][int]$MaxMinutes = 15,
    [ValidatePattern('^([A-Za-z0-9._-]+@)?[A-Za-z0-9._-]+$')][string]$SshTarget = '',
    [string]$SshKeyPath = '',
    [ValidatePattern('^i-[0-9a-f]{8,17}$')][string]$InstanceId = '',
    [ValidatePattern('^[a-z]{2}(-[a-z]+)+-\d$')][string]$AwsRegion = '',
    [ValidatePattern('^[A-Za-z0-9._-]+$')][string]$AwsProfile = '',
    [string]$StatePath = '',
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$remotePath = '/var/lib/cas26/worker-state.json'
$faultNames = @{ Healthy = ''; Delay = 'deep-thought'; Fail = 'marvin'; Pause = 'vogon' }

$targets = @(@($SshTarget, $InstanceId, $StatePath) | Where-Object { $_ })
if ($targets.Count -ne 1) { throw 'Name exactly one worker: -SshTarget (on-premises), -InstanceId (AWS over SSM) or -StatePath (local test).' }
if ($PSBoundParameters.ContainsKey('DelaySeconds') -and $Mode -ne 'Delay') { throw '-DelaySeconds is valid only with -Mode Delay.' }

$transport = if ($SshTarget) { 'Ssh' } elseif ($InstanceId) { 'Ssm' } else { 'Local' }
$targetLabel = switch ($transport) { 'Ssh' { "$SshTarget`:$remotePath" } 'Ssm' { "$InstanceId`:$remotePath" } default { [System.IO.Path]::GetFullPath($StatePath) } }

function Invoke-RemoteShell {
    param([Parameter(Mandatory)][string]$Script)
    $clean = ($Script -replace "`r", '')
    if ($transport -eq 'Ssh') {
        if (-not (Get-Command ssh -ErrorAction SilentlyContinue)) { throw 'ssh is not installed.' }
        $arguments = @('-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=accept-new')
        if ($SshKeyPath) { $arguments += @('-i', $SshKeyPath) }
        # PowerShell re-adds CRLF when piping text to a native command; strip it on the remote side.
        $arguments += @($SshTarget, "tr -d '\r' | sh -s")
        $output = $clean | & ssh @arguments 2>&1
        $code = $LASTEXITCODE
        return [pscustomobject]@{ ExitCode = $code; Output = (($output | ForEach-Object { "$_" }) -join "`n") }
    }
    if (-not (Get-Command aws -ErrorAction SilentlyContinue)) { throw 'The AWS CLI is not installed.' }
    $common = @()
    if ($AwsRegion) { $common += @('--region', $AwsRegion) }
    if ($AwsProfile) { $common += @('--profile', $AwsProfile) }
    $parameterFile = Join-Path ([System.IO.Path]::GetTempPath()) ("cas26-ssm-" + [guid]::NewGuid().ToString('N') + '.json')
    try {
        @{ commands = @($clean -split "`n") } | ConvertTo-Json -Compress | Set-Content -LiteralPath $parameterFile -Encoding utf8NoBOM
        $fileUri = 'file://' + ($parameterFile -replace '\\', '/')
        $commandId = & aws ssm send-command @common --instance-ids $InstanceId --document-name AWS-RunShellScript `
            --comment 'CAS26 worker-state change' --parameters $fileUri --query 'Command.CommandId' --output text
        if ($LASTEXITCODE -ne 0 -or -not $commandId) { throw 'aws ssm send-command failed; check the AWS identity, region and SSM registration.' }
    } finally {
        Remove-Item -LiteralPath $parameterFile -ErrorAction SilentlyContinue
    }
    $deadline = [datetime]::UtcNow.AddSeconds(90)
    do {
        Start-Sleep -Seconds 2
        $raw = & aws ssm get-command-invocation @common --command-id $commandId --instance-id $InstanceId --output json 2>$null
        $invocation = if ($LASTEXITCODE -eq 0 -and $raw) { ($raw -join "`n") | ConvertFrom-Json } else { $null }
        $status = if ($invocation) { $invocation.Status } else { 'Pending' }
    } while ($status -in @('Pending', 'InProgress', 'Delayed') -and [datetime]::UtcNow -lt $deadline)
    if (-not $invocation) { throw "SSM command $commandId returned no invocation before the deadline." }
    $code = if ($status -eq 'Success') { 0 } elseif ($invocation.ResponseCode -gt 0) { [int]$invocation.ResponseCode } else { 1 }
    return [pscustomobject]@{ ExitCode = $code; Output = ([string]$invocation.StandardOutputContent + [string]$invocation.StandardErrorContent) }
}

function Read-CurrentState {
    if ($transport -eq 'Local') {
        if (-not (Test-Path -LiteralPath $targetLabel)) { return $null }
        return Get-Content -LiteralPath $targetLabel -Raw
    }
    $result = Invoke-RemoteShell -Script "f=$remotePath`nif [ -f `"`$f`" ]; then echo CAS26-STATE-BEGIN; sudo -n cat `"`$f`"; echo; echo CAS26-STATE-END; else echo CAS26-STATE-MISSING; fi"
    if ($result.ExitCode -ne 0) { throw "Could not read $targetLabel (exit $($result.ExitCode)): $($result.Output)" }
    if ($result.Output -match 'CAS26-STATE-MISSING') { return $null }
    if ($result.Output -match '(?s)CAS26-STATE-BEGIN\s*(.*?)\s*CAS26-STATE-END') { return $Matches[1] }
    throw "Unexpected output while reading $targetLabel."
}

# 1. Read and check ownership of the current state.
$currentText = Read-CurrentState
$current = $null
if ($null -ne $currentText -and $currentText.Trim()) {
    try { $current = $currentText | ConvertFrom-Json } catch { throw "Refusing to change $targetLabel`: it exists but is not JSON, so it is not a CAS26 file." }
    if (-not $current.PSObject.Properties['project'] -or $current.project -ne 'cas26') { throw "Refusing to change $targetLabel`: it is not owned by CAS26." }
}
$previousMode = if ($current -and $current.PSObject.Properties['mode']) { [string]$current.mode } else { '' }
$previousUpdated = ''
if ($current -and $current.PSObject.Properties['updated_at'] -and $null -ne $current.updated_at) {
    # ConvertFrom-Json turns ISO timestamps into DateTime; write them back in the same UTC form.
    $previousUpdated = if ($current.updated_at -is [datetime]) { $current.updated_at.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') } else { [string]$current.updated_at }
}

# 2. Build the new state.
$now = [datetime]::UtcNow
$state = [ordered]@{ project = 'cas26'; mode = $Mode; faultName = $faultNames[$Mode] }
if ($Mode -eq 'Delay') { $state.delaySeconds = $DelaySeconds }
if ($Mode -ne 'Healthy') { $state.expires_at = $now.AddMinutes($MaxMinutes).ToString('yyyy-MM-ddTHH:mm:ssZ') }
$state.updated_at = $now.ToString('yyyy-MM-ddTHH:mm:ssZ')
$state.previous = [ordered]@{ mode = $(if ($previousMode) { $previousMode } else { $null }); updated_at = $(if ($previousUpdated) { $previousUpdated } else { $null }) }
$stateJson = $state | ConvertTo-Json -Compress -Depth 4

$result = [ordered]@{
    Project      = 'cas26'
    Target       = $targetLabel
    Transport    = $transport
    Mode         = $Mode
    FaultName    = $faultNames[$Mode]
    DelaySeconds = $(if ($Mode -eq 'Delay') { $DelaySeconds } else { $null })
    ExpiresAt    = $(if ($Mode -ne 'Healthy') { $state.expires_at } else { $null })
    PreviousMode = $(if ($previousMode) { $previousMode } else { '(no file)' })
    Changed      = ($previousMode -ne $Mode)
    DryRun       = [bool]$DryRun
    State        = $stateJson
}

if ($DryRun) {
    Write-Host "DRY RUN: $targetLabel is '$($result.PreviousMode)'; would write $stateJson" -ForegroundColor Yellow
    [pscustomobject]$result
    return
}

# 3. Write atomically, re-checking ownership on the target.
if ($transport -eq 'Local') {
    [System.IO.Directory]::CreateDirectory((Split-Path -Parent $targetLabel)) | Out-Null
    $temporaryPath = "$targetLabel.$([guid]::NewGuid().ToString('N')).tmp"
    try {
        Set-Content -LiteralPath $temporaryPath -Value $stateJson -Encoding utf8NoBOM
        [System.IO.File]::Move($temporaryPath, $targetLabel, $true)
    } finally {
        if (Test-Path -LiteralPath $temporaryPath) { Remove-Item -LiteralPath $temporaryPath }
    }
} else {
    $encoded = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($stateJson))
    $script = @(
        'set -e'
        "f=$remotePath"
        'if [ -f "$f" ] && ! sudo -n grep -q ''"project" *: *"cas26"'' "$f"; then echo "Refusing to change a state file not owned by CAS26" >&2; exit 2; fi'
        'sudo -n install -d -m 755 /var/lib/cas26'
        't=$(mktemp)'
        "echo '$encoded' | base64 -d > `"`$t`""
        'sudo -n install -m 644 "$t" "$f.tmp"'
        'sudo -n mv -f "$f.tmp" "$f"'
        'rm -f "$t"'
        'echo CAS26-STATE-WRITTEN'
    ) -join "`n"
    $write = Invoke-RemoteShell -Script $script
    if ($write.ExitCode -ne 0 -or $write.Output -notmatch 'CAS26-STATE-WRITTEN') {
        throw "Worker state change on $targetLabel failed (exit $($write.ExitCode)): $($write.Output)"
    }
}

$result.WrittenAtUtc = $state.updated_at
[pscustomobject]$result
