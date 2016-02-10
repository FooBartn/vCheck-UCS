# Start of Settings
# Do you want to see cleared events?
$ClearedEvents = $False 
# End of Settings

$UcsFaultTable = @()

If ($ClearedEvents -eq $False) {
	$FaultList = $Faults | Where { $_.Severity -ne "cleared" }
} Else {
	$FaultList = $Faults
}

Foreach ($Fault in $FaultList) {
	$Details = "" | Select-Object Object, Severity, Description, Date
	If ($Faults.Count -gt 0) {
		If ($Fault.Dn -like "*chassis*") {
			$LocSplit = ($Fault.Dn).Split("/")
			$Details.Object = $LocSplit[1] + "/" + $LocSplit[2]
		} Else {
			$LocSplit = ($Fault.Dn).Split("/")
			$Details.Object = $LocSplit[1]
		}
		
		$Details.Severity = $Fault.Severity
		$Details.Description = $Fault.Descr
		$Details.Date = $Fault.Created
	}

	$UcsFaultTable += $Details
}

$UcsFaultTable

$Title = "List of Recent Faults"
$Header =  "Number of Recent Faults: " + (@($Faults).Count)
$Comments = "Showing cleared events: $ClearedEvents"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"
