#Requires -Version 7.0
<# .SYNOPSIS
Read-only inventory and context checks. Results are observations, not certification of demo readiness.
No Azure login, extension installation, infrastructure deployment or workload mutation is performed.
#>
[CmdletBinding()]
param([Parameter(Mandatory)][string]$ConfigPath, [switch]$Offline, [string]$OutputPath)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Enter-DemoContext.ps1') -ConfigPath $ConfigPath -Offline:$Offline
$checks = [System.Collections.Generic.List[object]]::new()
function Add-Check([string]$Name, [string]$Status, [string]$Detail) {
    $checks.Add([pscustomobject]@{ Check=$Name; Status=$Status; Detail=$Detail; ObservedAtUtc=[datetime]::UtcNow.ToString('o') })
}
Add-Check 'Configuration' 'PASS' 'Identifiers and allowed resource types validated.'
if (-not $Offline) {
    $extensions = & az extension list --query '[].name' --output json --only-show-errors
    if ($LASTEXITCODE -ne 0) { Add-Check 'CLI extensions' 'FAIL' 'Could not read extension list.' }
    else {
        $installed = @($extensions | ConvertFrom-Json)
        foreach ($name in @('connectedmachine','resource-graph','connectedk8s','k8s-configuration','log-analytics')) {
            Add-Check "CLI extension: $name" $(if ($name -in $installed) {'PASS'} else {'MISSING'}) 'Install missing extensions during preparation, never on stage.'
        }
    }
    foreach ($field in @('OnPremArcResourceId','Ec2ArcResourceId','Ec2RbacArcResourceId','EksArcResourceId','SentinelWorkspaceResourceId','PolicyAssignmentId','Ec2PolicyAssignmentId','HealthModelResourceId')) {
        if (Test-DemoPending $field) { Add-Check $field 'PENDING' ([string]$Demo.$field); continue }
        $raw = & az resource show --ids $Demo.$field --output json --only-show-errors 2>$null
        if ($LASTEXITCODE -ne 0) { Add-Check $field 'FAIL' 'Read failed: check existence, permission, provider/API availability and context.'; continue }
        $resource = $raw | ConvertFrom-Json
        $state = @($resource.properties.status, $resource.properties.connectivityStatus, $resource.properties.provisioningState) | Where-Object { $_ }
        Add-Check $field 'READABLE' ("$($resource.id); reported state: $($state -join ', ')")
    }
    if (Test-DemoPending 'KubernetesContext') { Add-Check 'Kubernetes context' 'PENDING' ([string]$Demo.KubernetesContext) }
    elseif (Get-Command kubectl -ErrorAction SilentlyContinue) {
        $contexts = & kubectl config get-contexts -o name
        if ($LASTEXITCODE -eq 0 -and $Demo.KubernetesContext -cin @($contexts)) {
            Add-Check 'Kubernetes context' 'PRESENT' 'Configured context exists locally; cluster access and AWS-to-Arc identity mapping still need rehearsal.'
        } else { Add-Check 'Kubernetes context' 'FAIL' 'Configured EKS context missing or unreadable.' }
    } else { Add-Check 'kubectl' 'MISSING' 'Required for Flux workload verification.' }
}
foreach ($item in @('Shared landing zone and inherited policies','AMA / DCR association / fresh telemetry','Defender coverage and selected finding','Sentinel connector / rule / training incident','RBAC second-principal sign-in','Customer request / recovery','Flux identity / permissions / reconciliation','Saved fallback evidence and reset rehearsal')) {
    Add-Check $item 'MANUAL' 'Follow preparation.md and the corresponding runbook; not established by resource existence.'
}
if ($Offline) { Add-Check 'Cloud checks' 'NOT RUN' 'Offline validation only; no live evidence.' }
$checks | Format-Table -Wrap
if ($OutputPath) {
    $parent = Split-Path -Parent ([IO.Path]::GetFullPath($OutputPath))
    [IO.Directory]::CreateDirectory($parent) | Out-Null
    $checks | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $OutputPath -Encoding utf8
}
if (@($checks | Where-Object Status -in @('FAIL','MISSING')).Count) { throw 'Readiness checks found missing or failed items. Review the report.' }
