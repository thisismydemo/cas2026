#Requires -Version 7.0
<# .SYNOPSIS
Replay a rehearsal capture (JSON lines in the Cas26Service_CL stage-record shape) when a live query is slow on stage.
Prints the stage journey and the order outcome computed with the same rule as src/queries/service-outcome.kql:
any Success=false row fails the order; otherwise the order is Completed only when the coordinator wrote
Component=Coordinator, Stage=Completed, Success=true; anything else is Unresolved.
The banner names the capture so the presenter can say which step it stands in for.
#>
[CmdletBinding()]
param([Parameter(Mandatory)][string]$Path)
$ErrorActionPreference = 'Stop'
$rows = @(Get-Content -LiteralPath $Path | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json })
if (-not $rows.Count) { throw "No rows in $Path." }
Write-Host "REHEARSAL CAPTURE - $([IO.Path]::GetFileName($Path)) (captured result, not this minute's query)." -ForegroundColor Yellow
$rows | Sort-Object TimeGenerated |
    Format-Table TimeGenerated, OrderNumber, Cloud, Component, Stage, Success, DurationMs, FailureMode, Origin -AutoSize | Out-Host
$rows | Group-Object CorrelationId | ForEach-Object {
    $group = @($_.Group)
    $completed = @($group | Where-Object { $_.Component -eq 'Coordinator' -and $_.Stage -eq 'Completed' -and $_.Success }).Count
    $failures = @($group | Where-Object { -not $_.Success }).Count
    [pscustomobject]@{
        CorrelationId = $_.Name
        OrderNumber   = ($group | Select-Object -First 1).OrderNumber
        Origin        = ($group | Where-Object { $_.Component -eq 'Coordinator' -and $_.Stage -eq 'Accepted' } | Select-Object -First 1).Origin
        Outcome       = if ($failures) { 'Failed' } elseif ($completed) { 'Completed' } else { 'Unresolved' }
        FailureMode   = ($group | Where-Object { $_.FailureMode } | Select-Object -First 1).FailureMode
        Clouds        = (($group.Cloud | Sort-Object -Unique) -join ',')
        StageRows     = $group.Count
        FirstSeen     = ($group.TimeGenerated | Sort-Object | Select-Object -First 1)
        LastSeen      = ($group.TimeGenerated | Sort-Object | Select-Object -Last 1)
    }
}
