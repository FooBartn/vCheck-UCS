$Title = "Unassociated Service Profiles"
$Header =  "Unassociated Service Profiles"
$Comments = "Unassociated Profiles are not being utilized. Consider removing them."
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"


# Start of Settings 
# End of Settings 

$UnassociatedProfiles = @()

Foreach ($SvcProfile in $SvcProfiles) {
    $Details = '' | Select Name, State, Template
	If ($SvcProfile.AssocState -ne "associated") {
		$Details.Name = $SvcProfile.Name
        $Details.State = $SvcProfile.AssocState
        $Details.Template = $SvcProfile.SrcTemplName
        $UnassociatedProfiles += $Details
	}
}

$UnassociatedProfiles