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

Foreach ($SvcProfile in $SvcProfiles) {
    $Vnics = $SvcProfile | Get-UcsVnic
    Foreach ($Vnic in $Vnics) {
        $Details = '' | Select-Object Profile, vNIC, Policy, CDP, MacRegisterMode, UplinkFailAction
        $NetCtrlPolicy = Get-UcsNetworkControlPolicy -Dn $Vnic.OperNwCtrlPolicyName
        $ReportSetting = $false
        Foreach ($Setting in $NetCtrlPolicyHash.Keys) {
            If ($NetCtrlPolicy.$Setting -ne $NetCtrlPolicyHash.$Setting) {
                $Details.$Setting = $NetCtrlPolicy.$Setting
                $ReportSetting = $true
            }
        }
        # If detail object is not null, define port and add it to the array
        If ($ReportSetting) {
            $Details.Profile = $SvcProfile.Name
            $Details.Policy = $NetCtrlPolicy.Name
            $Details.vNic = $Vnic.Name
            $NetCtrlPolicyTable += $Details
        }
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