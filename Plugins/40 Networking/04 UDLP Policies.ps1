# Start of Settings
# Define whether UDLP should be enabled (enabled/disabled):
$UdlpState = 'enabled'
# Define UDLP mode: (normal/aggressive):
$UdlpMode = 'aggressive'
# Define UDLP recovery setting: (none/reset):
$UdlpRecoveryAction = 'reset'
# Define UDLP recovery interval (Seconds between Udlp checking to see if it can recover):
$UdlpRecoveryInt = 15
# End of Settings 

$UdlpPolicyTable = @()
$UdlpPolicies = Get-UcsFabricUdldLinkPolicy
$UdlpSettings = Get-UcsFabricUdldPolicy

Foreach ($UdlpPolicy in $UdlpPolicies)
{
    If ($UdlpPolicy.AdminState -ne $UdlpState -OR $UdlpPolicy.Mode -ne $UdlpMode)
    {
        $Details = '' | Select Policy, Location, State, Suspend, Rate, RecoveryAction, RecoveryInterval
        $Details.Policy = $UdlpPolicy.Name
        $Details.Location = $UdlpPolicy.Dn
        $Details.State = $UdlpPolicy.AdminState
        $Details.Suspend = $UdlpPolicy.SuspendIndividual
        $Details.Rate = $UdlpPolicy.FastTimer
        
        If ($UdlpSettings.RecoveryAction -ne $UdlpRecoveryAction -OR $UdlpSettings.MsgInterval -ne $UdlpRecoveryInt)
        {
            $Details.RecoveryAction = $UdlpSettings.RecoveryAction
            $Details.RecoveryInterval = $UdlpSettings.MsgInterval
        }
        
        $UdlpPolicyTable += $Details
    }
}

$UdlpPolicyTable

$Title = "UDLP Policies"
$Header =  "UDLP Policies"
$Comments = "Preferred UDLP Settings: State: $UdlpState, Mode: $UdlpMode, Recovery: $UdlpRecovery, Recovery Interval: $UdlpRecoveryInt"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"