#Requires -Version 7.0
<# .SYNOPSIS
Load validated demo identifiers and verify the existing Azure CLI context. No login or cloud writes.
Dot-source from the repository root to make $Demo available to the runbook commands.
#>
[CmdletBinding()]
param([Parameter(Mandatory)][string]$ConfigPath, [switch]$Offline)
$ErrorActionPreference = 'Stop'
$Demo = Get-Content -LiteralPath $ConfigPath -Raw | ConvertFrom-Json
$example = Get-Content -LiteralPath (Join-Path $PSScriptRoot '../config/demo.example.json') -Raw | ConvertFrom-Json
# A rehearsal copy may record a target it has not populated as 'PENDING: <reason>'.
# Such values are skipped by the format checks below and reported as PENDING by Test-DemoReadiness; a demo that uses one cannot run live.
$pendingAllowed = @('OnPremArcResourceId','Ec2PolicyAssignmentId','HealthModelResourceId','ServiceUrl','FluxRepositoryUrl','FluxBranch','KubernetesContext')
function Test-DemoPending([string]$Field) { return ($Field -in $pendingAllowed) -and ([string]$Demo.$Field -match '^PENDING') }
foreach ($field in $example.PSObject.Properties.Name) {
    if (-not $Demo.PSObject.Properties[$field] -or [string]::IsNullOrWhiteSpace([string]$Demo.$field) -or $Demo.$field -match 'REPLACE_WITH') {
        throw "Populate $field in $ConfigPath (or mark it 'PENDING: reason' in a rehearsal copy). No Azure command has been run."
    }
}
foreach ($field in @('TenantId','SubscriptionId','LogAnalyticsWorkspaceId')) {
    $parsedGuid = [guid]::Empty
    if (-not [guid]::TryParse($Demo.$field, [ref]$parsedGuid)) { throw "$field must be a GUID." }
}
foreach ($field in @('OnPremArcResourceId','Ec2ArcResourceId','Ec2RbacArcResourceId','EksArcResourceId','SentinelWorkspaceResourceId')) {
    if (Test-DemoPending $field) { continue }
    $id = [string]$Demo.$field
    # Arc resources live in the workload subscription; the Sentinel workspace lives in the security subscription by design.
    $prefix = if ($field -eq 'SentinelWorkspaceResourceId') { '/subscriptions/' } else { '/subscriptions/' + $Demo.SubscriptionId + '/resourceGroups/' }
    if (-not $id.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) { throw "$field is outside the configured subscription." }
    $type = switch ($field) {
        'EksArcResourceId' { 'Microsoft.Kubernetes/connectedClusters' }
        'SentinelWorkspaceResourceId' { 'Microsoft.OperationalInsights/workspaces' }
        default { 'Microsoft.HybridCompute/machines' }
    }
    $pattern = '^/subscriptions/[^/]+/resourceGroups/([^/]+)/providers/' + [regex]::Escape($type) + '/[^/]+$'
    if ($id -notmatch $pattern) { throw "$field must identify one $type resource." }
    if ($field -ne 'SentinelWorkspaceResourceId') {
        $expectedRg = if ($field -in @('Ec2ArcResourceId','Ec2RbacArcResourceId','EksArcResourceId')) { $Demo.AwsResourceGroup } else { $Demo.OperationsResourceGroup }
        if ($Matches[1] -ine $expectedRg) { throw "$field does not land in its configured resource group." }
    }
}
foreach ($field in @('PolicyAssignmentId','Ec2PolicyAssignmentId')) {
    if (Test-DemoPending $field) { continue }
    if ($Demo.$field -notmatch '^/(subscriptions/[^/]+(/resourceGroups/[^/]+)?|providers/Microsoft.Management/managementGroups/[^/]+)/providers/Microsoft.Authorization/policyAssignments/[^/]+$') {
        throw "$field must be a full subscription, RG or management-group policy assignment ID."
    }
}
foreach ($field in @('ServiceUrl','FluxRepositoryUrl')) {
    if (Test-DemoPending $field) { continue }
    $parsedUri = $null
    if (-not [uri]::TryCreate($Demo.$field, [UriKind]::Absolute, [ref]$parsedUri) -or $parsedUri.Scheme -notin @('http','https') -or $parsedUri.UserInfo) {
        throw "$field must be an HTTP(S) URL without embedded credentials."
    }
}
if (-not $Offline) {
    if (-not (Get-Command az -ErrorAction SilentlyContinue)) { throw 'Azure CLI is not installed.' }
    $contextText = & az account show --output json --only-show-errors
    if ($LASTEXITCODE -ne 0) { throw 'Azure CLI account lookup failed. Sign in separately, then retry.' }
    $context = $contextText | ConvertFrom-Json
    if ($context.id -ine $Demo.SubscriptionId -or $context.tenantId -ine $Demo.TenantId) {
        throw 'Azure CLI tenant/subscription mismatch. Select the intended context explicitly before continuing.'
    }
}
$pending = @($pendingAllowed | Where-Object { Test-DemoPending $_ })
if ($pending.Count) { Write-Host "PENDING targets (demos using them cannot run live): $($pending -join ', ')" }
Write-Host "Demo configuration validated ($(@{ $true='offline'; $false='current Azure context' }[[bool]$Offline])). Resource readiness is a separate check."
