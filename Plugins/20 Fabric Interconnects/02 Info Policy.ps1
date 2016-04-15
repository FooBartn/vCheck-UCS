# Start of Settings
# Define Info Policy state (enabled/disabled):
$InfoPolicyState = 'enabled'
# End of Settings

$UcsInfoPolTable = @()
$UcsInfoPolicy = Get-UcsTopInfoPolicy

If($UcsInfoPolicy.State -ne $InfoPolicyState) {
    $Details = '' | Select Name, State
    $Details.Name = $UcsInfoPolicy.Rn
    $Details.State = $UcsInfoPolicy.State
    $UcsInfoPolTable += $Details    
}

$UcsInfoPolTable

$Title = "Fabric Interconnect Info Policy"
$Header =  "Fabric Interconnect Info Policy"
$Comments = "Preferred Info Policy Setting -- State: $InfoPolicyState"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"