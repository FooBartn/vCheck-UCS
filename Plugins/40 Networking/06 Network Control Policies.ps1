# Start of Settings
# Define CDP State (enabled/disabled):
$CdpState = 'enabled'
# Define MAC Register Mode (only-native-vlan/all-host-vlans):
$MacRegisterMode = 'only-native-vlan'
# Define Action on Uplink Failure (link-down/warning):
$UplinkFailureAction = 'link-down'
# End of Settings 

$NetCtrlPolicyTable = @()
$NetCtrlPolicies = Get-UcsNetworkControlPolicy

Foreach ($NetCtrlPolicy in $NetCtrlPolicies) {
    
    If ($NetCtrlPolicy.Cdp -ne $CdpState -OR $NetCtrlPolicy.MacRegisterMode -ne $MacRegisterMode -OR $NetCtrlPolicy.UplinkFailAction -ne $UplinkFailureAction) {
        $Details = '' | Select Policy, Location, Cdp, MacRegisterMode, UplinkFailureAction
        $Details.Policy = $NetCtrlPolicy.Name
        $Details.Location = $NetCtrlPolicy.Dn
        $Details.Cdp = $NetCtrlPolicy.Cdp
        $Details.MacRegisterMode = $NetCtrlPolicy.MacRegisterMode
        $Details.UplinkFailureAction = $NetCtrlPolicy.UplinkFailAction
        $NetCtrlPolicyTable += $Details
    }
}

$NetCtrlPolicyTable

$Title = "Network Control Policies"
$Header =  "Network Control Policies"
$Comments = "Preferred Network Control Settings -- CDP: $CdpState, Mac Register Mode: $MacRegisterMode, Uplink Failure Action: $UplinkFailureAction"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"