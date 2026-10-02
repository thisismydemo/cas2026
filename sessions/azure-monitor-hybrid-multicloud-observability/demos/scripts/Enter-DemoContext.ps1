#Requires -Version 7.0
<# .SYNOPSIS
Load validated Whole-Service Observability demo identifiers and check the existing Azure CLI context.
No sign-in and no cloud writes. Dot-source from the repository root so $Demo is available to runbook commands:

    . ./sessions/azure-monitor-hybrid-multicloud-observability/demos/scripts/Enter-DemoContext.ps1 -ConfigPath ./sessions/azure-monitor-hybrid-multicloud-observability/demos/config/demo.local.json

Every identifier in config/demo.example.json must be filled with a verified value before delivery.
#>
[CmdletBinding()]
param([Parameter(Mandatory)][string]$ConfigPath, [switch]$Offline)
$ErrorActionPreference = 'Stop'
$Demo = Get-Content -LiteralPath $ConfigPath -Raw | ConvertFrom-Json
$example = Get-Content -LiteralPath (Join-Path $PSScriptRoot '../config/demo.example.json') -Raw | ConvertFrom-Json

foreach ($field in $example.PSObject.Properties.Name) {
    if (-not $Demo.PSObject.Properties[$field] -or [string]::IsNullOrWhiteSpace([string]$Demo.$field) -or $Demo.$field -match 'REPLACE_WITH') {
        throw "Populate $field in $ConfigPath. No Azure command has been run."
    }
}
foreach ($field in @('TenantId', 'MonitoringSubscriptionId', 'WorkloadSubscriptionId', 'LogAnalyticsWorkspaceId')) {
    $parsed = [guid]::Empty
    if (-not [guid]::TryParse($Demo.$field, [ref]$parsed)) { throw "$field must be a GUID." }
}

# Monitoring resources live in the monitoring subscription; Arc and application resources in the Arc landing-zone subscription.
$expected = [ordered]@{
    LogAnalyticsWorkspaceResourceId = @('MonitoringSubscriptionId', 'Microsoft.OperationalInsights/workspaces')
    AzureMonitorWorkspaceResourceId = @('MonitoringSubscriptionId', 'Microsoft.Monitor/accounts')
    RequestsDcrResourceId           = @('MonitoringSubscriptionId', 'Microsoft.Insights/dataCollectionRules')
    LinuxDcrResourceId              = @('MonitoringSubscriptionId', 'Microsoft.Insights/dataCollectionRules')
    HealthModelResourceId           = @('MonitoringSubscriptionId', 'Microsoft.CloudHealth/healthmodels')
    WorkbookResourceId              = @('MonitoringSubscriptionId', 'Microsoft.Insights/workbooks')
    AwsWorkerArcResourceId          = @('WorkloadSubscriptionId', 'Microsoft.HybridCompute/machines')
    FrontDoorProfileResourceId      = @('WorkloadSubscriptionId', 'Microsoft.Cdn/profiles')
}
foreach ($field in $expected.Keys) {
    $subscription = $Demo.($expected[$field][0])
    $type = $expected[$field][1]
    $pattern = '^/subscriptions/' + [regex]::Escape($subscription) + '/resourceGroups/([^/]+)/providers/' + [regex]::Escape($type) + '/[^/]+$'
    if ([string]$Demo.$field -inotmatch $pattern) { throw "$field must be one $type resource in the configured $($expected[$field][0])." }
    if ($field -eq 'AwsWorkerArcResourceId' -and $Matches[1] -ine $Demo.AwsResourceGroup) { throw 'AwsWorkerArcResourceId is not in the configured AwsResourceGroup.' }
}
if ($Demo.AwsWorkerInstanceId -notmatch '^i-[0-9a-f]{8,17}$') {
    throw 'AwsWorkerInstanceId must be an EC2 instance ID (i-...).'
}
if ($Demo.HealthModelApiVersion -notmatch '^\d{4}-\d{2}-\d{2}(-preview)?$') { throw 'HealthModelApiVersion must look like 2026-09-01-preview.' }
$uri = $null
if (-not [uri]::TryCreate($Demo.ServiceUrl, [UriKind]::Absolute, [ref]$uri) -or $uri.Scheme -ne 'https' -or $uri.UserInfo -or $uri.Query) {
    throw 'ServiceUrl must be the HTTPS Front Door endpoint without credentials or a query string.'
}

if (-not $Offline) {
    if (-not (Get-Command az -ErrorAction SilentlyContinue)) { throw 'Azure CLI is not installed.' }
    $contextText = & az account show --output json --only-show-errors
    if ($LASTEXITCODE -ne 0) { throw 'Azure CLI account lookup failed. Sign in separately, then retry.' }
    $context = $contextText | ConvertFrom-Json
    if ($context.tenantId -ine $Demo.TenantId) { throw 'Azure CLI tenant mismatch. Select the intended tenant explicitly before continuing.' }
    if ($context.id -notin @($Demo.MonitoringSubscriptionId, $Demo.WorkloadSubscriptionId)) {
        throw 'The Azure CLI subscription is neither the monitoring nor the workload subscription. Select one explicitly.'
    }
}
Write-Host "Observability demo configuration validated ($(if ($Offline) { 'offline' } else { 'current Azure context' }))."
