#Requires -Version 7.0
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][uri]$Endpoint,
    [Parameter(Mandatory)][ValidatePattern('^dcr-[a-zA-Z0-9]+$')][string]$ImmutableId,
    [Parameter(Mandatory)][string]$JsonLinesPath
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ($Endpoint.Scheme -ne 'https' -or $Endpoint.UserInfo -or $Endpoint.Host -notlike '*.ingest.monitor.azure.com') { throw 'Use the public Azure Logs Ingestion endpoint without embedded credentials.' }
$rows = @(Get-Content -LiteralPath $JsonLinesPath | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_ | ConvertFrom-Json })
if ($rows.Count -eq 0) { throw 'No telemetry records to send.' }
foreach ($row in $rows) { if ($row.Service -ne 'cas26-requests') { throw 'Only CAS26 service rows may be sent.' } }
$body = ConvertTo-Json -InputObject $rows -Depth 5 -Compress
if ([System.Text.Encoding]::UTF8.GetByteCount($body) -gt 900000) { throw 'Batch too large. Split this capture into smaller files.' }
$uri = "$($Endpoint.AbsoluteUri.TrimEnd('/'))/dataCollectionRules/$ImmutableId/streams/Custom-Cas26Service?api-version=2023-01-01"
if ($PSCmdlet.ShouldProcess($Endpoint.Host, "Send $($rows.Count) CAS26 telemetry rows")) {
    $tokenJson = & az account get-access-token --resource https://monitor.azure.com --query accessToken --output json --only-show-errors
    if ($LASTEXITCODE -ne 0) { throw 'Unable to obtain a telemetry token using the current authenticated identity.' }
    try {
        $token = ($tokenJson -join "`n") | ConvertFrom-Json
        Invoke-RestMethod -Uri $uri -Method Post -Headers @{ Authorization = "Bearer $token" } -ContentType 'application/json; charset=utf-8' -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) | Out-Null
        [pscustomobject]@{ Project = 'cas26'; RowsSent = $rows.Count; Warning = 'Re-sending this file duplicates records. Archive successful batches.' }
    } finally { $token = $null; $tokenJson = $null }
}
