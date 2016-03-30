# Start of Settings
# Define CDP State (enabled/disabled):
$CdpState = 'enabled'
# Define MAC Register Mode (only-native-vlan/all-host-vlans):
$MacRegisterMode = 'only-native-vlan'
# Define Action on Uplink Failure (link-down/warning):
$UplinkFailureAction = 'link-down'
# End of Settings 

# Create Hash Table for Comparison
$NetCtrlPolicyHash = @{
    Cdp = $CdpState
    MacRegisterMode = $MacRegisterMode
    UplinkFailAction = $UplinkFailureAction
}

$NetCtrlPolicyTable = @()
$NetCtrlPolicies = Get-UcsNetworkControlPolicy


Foreach ($NetCtrlPolicy in $NetCtrlPolicies) {
    # Use keys in hash table to compare expected data to actual data
    Foreach ($Setting in $NetCtrlPolicyHash.Keys) {
        $Details = '' | Select Name, Cdp, MacRegisterMode, UplinkFailAction
        If ($NetCtrlPolicy.$Setting -ne $NetCtrlPolicyHash.$Setting) {
            $BadNetCtrlSettings.$Setting = $netCtrlPolicy.$Setting
        }
    }
    # If detail object is not null, define port and add it to the array
    If ($Details) {
        $Details.Name = $NetCtrlPolicy.Name
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