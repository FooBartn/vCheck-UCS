$Title = "Unassociated Service Profiles"
$Header =  "Unassociated Service Profiles"
$Comments = "Unassociated Profiles are not being utilized. Consider removing them."
$Display = "List"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"


# Start of Settings 
# End of Settings 

$UnassocProfs = New-Object -TypeName PSObject

Foreach ($SvcProf in $SvcProfs) {
	If ($SvcProf.AssocState -ne "associated") {
		$UnassocProfs | Add-Member NoteProperty "$($SvcProf.Name)" $SvcProf.AssocState
	}
}

$UnassocProfs