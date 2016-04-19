# Start of Settings
# Define whether LACP Suspend Individual should be on (true/false):
$LacpSuspend = 'true'
# Define LACP Rate setting (normal/fast):
$LacpRate = 'normal'
# End of Settings 

$LacpPolicyTable = @()
$ReportSetting = $false

# Create Hash Table for Comparison
$LacpSettingsHashTable = @{
    SuspendIndividual = $LacpSuspend
    FastTimer = $LacpRate
}

# Check each uplink port
Foreach ($UplinkPortChannel in $UplinkPortChannels) {
    $LacpPolicy = Get-UcsFabricLacpPolicy -Name $UplinkPortChannel.LacpPolicyName -Dn $UplinkPortChannel.OperLacpPolicyName
    $Details = '' | Select SwitchId, PortChannel, Name, SuspendIndividual, FastTimer
    # Use keys in hash table to compare expected data to actual data
    Foreach ($Setting in $LacpSettingsHashTable.Keys) {
        # If the actual value is not equal to the expected value
        If ($LacpPolicy.$Setting -ne $LacpSettingsHashTable.$Setting) {
            $Details.$Setting = $LacpPolicy.$Setting
            $ReportSetting = $true
        }
    }
    # If detail object is not null, define port and add it to the array
    If ($ReportSetting) {
        $Details.SwitchId = $UplinkPortChannel.SwitchId
        $Details.PortChannel = $UplinkPortChannel.Rn
        $Details.Name = $LacpPolicy.Name
        $LacpPolicyTable += $Details
    }
}

$LacpPolicyTable

$Title = "LACP Policies"
$Header =  "LACP Policies"
$Comments = "Preferred LACP Settings -- Suspend Individual: $LacpSuspend, Rate: $LacpRate"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.5
$PluginCategory = "UCS"