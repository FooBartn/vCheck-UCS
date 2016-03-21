# Start of Settings
# Define default vNIC behavior (none/hw-inherit). Set "Default vNIC Behavior" policy setting to 'none' to keep vNICs from being created where they weren't explicitly created:
$ReqVnicBehavior = 'none'
# Define default vHBA behavior (none/hw-inherit). Set "Default vHBA Behavior" policy setting to 'none' to keep vNICs from being created where they weren't explicitly created:
$ReqVhbaBehavior = 'none'
# End of Settings 

$AdapterPolicyTable = @()
$VnicBehPolicy = Get-UcsVnicVnicBehPolicy
$VhbaBehPolicy = Get-UcsVnicVhbaBehPolicy

If ($VnicBehPolicy.Action -ne $ReqVnicBehavior) {
    $Details = '' | Select Policy, Action
    $Details.Policy = $VnicBehPolicy.Name
    $Details.Action = $VnicBehPolicy.Action
    $AdapterPolicyTable += $Details
}

If ($VhbaBehPolicy.Action -ne $ReqVhbaBehavior) {
    $Details = '' | Select Policy, Action
    $Details.Policy = $VhbaBehPolicy.Name
    $Details.Action = $VhbaBehPolicy.Action
    $AdapterPolicyTable += $Details
}

$AdapterPolicyTable

$Title = "Default Adapter Behavior"
$Header =  "Default Adapter Behavior"
$Comments = "Preferred Adapter Settings -- vNIC Action: $ReqVnicBehavior, vHBA Action: $ReqVhbaBehavior"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 0.1
$PluginCategory = "UCS"