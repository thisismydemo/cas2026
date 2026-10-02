#Requires -Version 7.0
<#
.SYNOPSIS
    Place IIC Hybrid Orders through the public Front Door endpoint and return one result per order.

.DESCRIPTION
    Implements the "Demo helper contract" in lab/design/HYBRID-APPLICATION-HEALTH-DESIGN.md. Both CAS26
    sessions call this script by name (Hybrid H16/H23F, Observability M02/M03), so its name,
    parameters and return shape are a contract.

    ENDPOINT ASSUMPTION (the lab design does not name the order API path):
      - The order is placed with  POST {BaseUri}/api/orders  (override with -OrderPath).
      - Request body (JSON):
          { "customer": "IIC", "item": "Towel (Standard Issue)", "quantity": 42,
            "demoTag": true|false, "clientRequestId": "<guid>" }
      - The coordinator answers either synchronously with the final order, or with
        HTTP 202 and a Location header that is polled with GET until the order is final
        or -TimeoutSeconds elapses.
      - The response is expected to carry (camelCase or PascalCase accepted):
          correlationId, orderNumber, origin, status (Completed|Failed|TimedOut),
          failureMode, stages[] { cloud, component, stage, success, durationMs }
    The response shape is validated defensively: a missing correlation ID or an unknown
    status fails the call instead of being reported as success. Update this header, the
    scripts README and the lab design together if the deployed API differs.

    Safety: no credential, token or key is ever read, sent or printed by this script. A URI
    with embedded user information, or a query string that carries a key/signature/token,
    is rejected. Faults apply only to orders placed with -DemoTag.

.PARAMETER BaseUri
    Front Door endpoint of IIC Hybrid Orders (https://...). Required.

.PARAMETER Count
    Number of orders to place, 1-100. Default 1.

.PARAMETER IntervalSeconds
    Pause between orders, 0-60 seconds. Default 1.

.PARAMETER DemoTag
    Mark the order(s) as demo orders so worker fault modes apply to them.

.PARAMETER JsonLinesPath
    Optional capture file. One compact JSON object per order (the returned object) is appended.

.PARAMETER OrderPath
    Order API path relative to BaseUri. Default /api/orders (see ENDPOINT ASSUMPTION).

.PARAMETER TimeoutSeconds
    Client-side wait for a final order result, 5-300 seconds. Default 60. When it elapses the
    order is reported with Status TimedOut.

.OUTPUTS
    One object per order: CorrelationId, RequestId (alias of CorrelationId), OrderNumber, Origin,
    Status, Success, ElapsedMs, FailureMode, DemoTag, Stages[], HttpStatus, PlacedAtUtc.

.EXAMPLE
    $order = ./sessions/<session>/demos/scripts/Invoke-Cas26Request.ps1 -BaseUri $Demo.ServiceUrl -DemoTag
    $order.Stages | Format-Table Cloud, Component, Stage, Success, DurationMs

.NOTES
    Version: 2.0.0 (2026-09-26) - rewritten for IIC Hybrid Orders; the retired /request sample
    service contract is no longer supported.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][uri]$BaseUri,
    [ValidateRange(1, 100)][int]$Count = 1,
    [ValidateRange(0, 60)][int]$IntervalSeconds = 1,
    [switch]$DemoTag,
    [string]$JsonLinesPath,
    [ValidatePattern('^/[A-Za-z0-9/_\-.]*$')][string]$OrderPath = '/api/orders',
    [ValidateRange(5, 300)][int]$TimeoutSeconds = 60
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$allowedStatus = @('Completed', 'Failed', 'TimedOut')
$allowedCloud = @('Azure', 'AWS', 'OnPrem')
$allowedComponent = @('Coordinator', 'Transport', 'OnPremWorker', 'AwsWorker')
$allowedStage = @('Accepted', 'Dispatched', 'Started', 'Completed', 'Failed', 'TimedOut', 'DeadLettered')

if (-not $BaseUri.IsAbsoluteUri -or $BaseUri.Scheme -notin @('http', 'https')) {
    throw 'BaseUri must be an absolute HTTP(S) URI (the Front Door endpoint).'
}
if ($BaseUri.UserInfo) { throw 'BaseUri must not contain embedded credentials.' }
if ($BaseUri.Query -match '(?i)(^|[?&])(code|key|sig|signature|token|access_token|apikey|api-key)=') {
    throw 'BaseUri must not carry a key, signature or token in its query string.'
}
if ($BaseUri.Scheme -eq 'http') { Write-Warning 'BaseUri uses plain HTTP; the Front Door endpoint should be HTTPS.' }

$orderUri = [uri]::new($BaseUri, $OrderPath)

function Get-Field {
    param([object]$Object, [string[]]$Names)
    if ($null -eq $Object) { return $null }
    foreach ($name in $Names) {
        $property = $Object.PSObject.Properties | Where-Object { $_.Name -ieq $name } | Select-Object -First 1
        if ($property) { return $property.Value }
    }
    return $null
}

function ConvertTo-OrderResult {
    param([object]$Body, [int]$HttpStatus, [double]$ElapsedMs, [datetime]$PlacedAt)
    $correlationId = [string](Get-Field $Body @('correlationId', 'CorrelationId'))
    if ([string]::IsNullOrWhiteSpace($correlationId)) {
        throw "The order endpoint returned HTTP $HttpStatus without a correlationId; the response does not match the IIC order contract."
    }
    $status = [string](Get-Field $Body @('status', 'Status'))
    $match = $allowedStatus | Where-Object { $_ -ieq $status } | Select-Object -First 1
    if (-not $match) { throw "Order $correlationId returned status '$status'; expected one of $($allowedStatus -join ', ')." }
    $stages = @(
        foreach ($raw in @(Get-Field $Body @('stages', 'Stages'))) {
            if ($null -eq $raw) { continue }
            $stage = [pscustomobject]@{
                Cloud      = [string](Get-Field $raw @('cloud', 'Cloud'))
                Component  = [string](Get-Field $raw @('component', 'Component'))
                Stage      = [string](Get-Field $raw @('stage', 'Stage'))
                Success    = [bool](Get-Field $raw @('success', 'Success'))
                DurationMs = [long](Get-Field $raw @('durationMs', 'DurationMs'))
            }
            if ($stage.Cloud -notin $allowedCloud -or $stage.Component -notin $allowedComponent -or $stage.Stage -notin $allowedStage) {
                Write-Warning "Order $correlationId has a stage outside the telemetry contract: $($stage.Cloud)/$($stage.Component)/$($stage.Stage)."
            }
            $stage
        }
    )
    [pscustomobject]@{
        CorrelationId = $correlationId
        RequestId     = $correlationId
        OrderNumber   = [string](Get-Field $Body @('orderNumber', 'OrderNumber'))
        Origin        = [string](Get-Field $Body @('origin', 'Origin'))
        Status        = $match
        Success       = ($match -eq 'Completed')
        ElapsedMs     = [long][math]::Round($ElapsedMs)
        FailureMode   = [string](Get-Field $Body @('failureMode', 'FailureMode'))
        DemoTag       = [bool]$DemoTag
        Stages        = $stages
        HttpStatus    = $HttpStatus
        PlacedAtUtc   = $PlacedAt.ToString('o')
    }
}

function Read-JsonBody {
    param($Response)
    $text = [string]$Response.Content
    if ([string]::IsNullOrWhiteSpace($text)) { return $null }
    try { return $text | ConvertFrom-Json -Depth 10 }
    catch { throw "The order endpoint returned HTTP $($Response.StatusCode) with a body that is not JSON." }
}

for ($index = 0; $index -lt $Count; $index++) {
    $body = [ordered]@{
        customer        = 'IIC'
        item            = 'Towel (Standard Issue)'
        quantity        = 42
        demoTag         = [bool]$DemoTag
        clientRequestId = [guid]::NewGuid().ToString()
    } | ConvertTo-Json -Compress

    if (-not $PSCmdlet.ShouldProcess($orderUri.AbsoluteUri, "POST IIC order (demoTag=$([bool]$DemoTag))")) {
        Write-Host "WHATIF: POST $($orderUri.AbsoluteUri) $body"
        continue
    }

    $placedAt = [datetime]::UtcNow
    $clock = [System.Diagnostics.Stopwatch]::StartNew()
    $result = $null
    try {
        $response = Invoke-WebRequest -Method Post -Uri $orderUri -Body $body -ContentType 'application/json' `
            -TimeoutSec $TimeoutSeconds -SkipHttpErrorCheck -MaximumRedirection 0
        $parsed = Read-JsonBody $response
        $location = $response.Headers['Location'] | Select-Object -First 1
        while ($response.StatusCode -eq 202 -and $location -and $clock.Elapsed.TotalSeconds -lt $TimeoutSeconds) {
            $pollUri = [uri]::new($BaseUri, [string]$location)
            if ($pollUri.Host -ne $BaseUri.Host) { throw 'The order endpoint redirected polling to a different host; refusing to follow.' }
            Start-Sleep -Seconds 2
            $response = Invoke-WebRequest -Method Get -Uri $pollUri -TimeoutSec $TimeoutSeconds -SkipHttpErrorCheck -MaximumRedirection 0
            $parsed = Read-JsonBody $response
            if ($response.StatusCode -ne 202) { break }
            $parsedStatus = [string](Get-Field $parsed @('status', 'Status'))
            if ($parsedStatus -in $allowedStatus) { break }
        }
        $clock.Stop()
        if ($response.StatusCode -eq 202) {
            $correlationId = [string](Get-Field $parsed @('correlationId', 'CorrelationId'))
            $result = [pscustomobject]@{
                CorrelationId = $correlationId; RequestId = $correlationId
                OrderNumber = [string](Get-Field $parsed @('orderNumber', 'OrderNumber')); Origin = [string](Get-Field $parsed @('origin', 'Origin'))
                Status = 'TimedOut'; Success = $false; ElapsedMs = [long]$clock.Elapsed.TotalMilliseconds
                FailureMode = ''; DemoTag = [bool]$DemoTag; Stages = @(); HttpStatus = 202; PlacedAtUtc = $placedAt.ToString('o')
            }
        }
        elseif ($response.StatusCode -ge 500 -and $null -eq $parsed) {
            throw "The order endpoint returned HTTP $($response.StatusCode) with no order body."
        }
        else {
            $result = ConvertTo-OrderResult -Body $parsed -HttpStatus ([int]$response.StatusCode) -ElapsedMs $clock.Elapsed.TotalMilliseconds -PlacedAt $placedAt
        }
    }
    catch {
        $failure = $_.Exception
        $isTimeout = ($failure -is [System.Threading.Tasks.TaskCanceledException]) -or ($failure -is [System.TimeoutException]) -or
            ($failure.InnerException -is [System.TimeoutException]) -or ($failure.Message -match '(?i)timeout|timed out')
        if (-not $isTimeout) { throw }
        $clock.Stop()
        $result = [pscustomobject]@{
            CorrelationId = $null; RequestId = $null; OrderNumber = ''; Origin = ''
            Status = 'TimedOut'; Success = $false; ElapsedMs = [long]$clock.Elapsed.TotalMilliseconds
            FailureMode = ''; DemoTag = [bool]$DemoTag; Stages = @(); HttpStatus = 0; PlacedAtUtc = $placedAt.ToString('o')
        }
        Write-Warning "No order result within $TimeoutSeconds s; find the order in Cas26Service_CL by time window."
    }

    if ($JsonLinesPath) {
        $capturePath = [System.IO.Path]::GetFullPath($JsonLinesPath)
        [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($capturePath)) | Out-Null
        Add-Content -LiteralPath $capturePath -Value ($result | ConvertTo-Json -Compress -Depth 6) -Encoding utf8NoBOM
    }
    $result
    if ($index -lt ($Count - 1) -and $IntervalSeconds -gt 0) { Start-Sleep -Seconds $IntervalSeconds }
}
