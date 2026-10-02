#Requires -Version 7.0
[CmdletBinding(SupportsShouldProcess)]
param([string]$Message = 'CAS26 request demonstration', [switch]$RegisterSource)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if (-not $IsWindows) { throw 'This event demonstration requires the Windows guest.' }
if (-not [System.Diagnostics.EventLog]::SourceExists('CAS26Demo')) {
    if (-not $RegisterSource) { throw 'Register CAS26Demo once using -RegisterSource in an elevated session.' }
    if ($PSCmdlet.ShouldProcess('Application/CAS26Demo','Register event source')) { [System.Diagnostics.EventLog]::CreateEventSource('CAS26Demo','Application') }
}
if ($PSCmdlet.ShouldProcess('Application/CAS26Demo','Write demonstration event')) {
    $eventMessage = "CAS26 $([DateTime]::UtcNow.ToString('o')) $Message"
    [System.Diagnostics.EventLog]::WriteEntry('CAS26Demo',$eventMessage,[System.Diagnostics.EventLogEntryType]::Information,2601)
    Write-Output $eventMessage
}
