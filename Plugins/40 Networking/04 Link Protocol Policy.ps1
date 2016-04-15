# Start of Settings
# Define UDLP recovery setting: (none/reset):
$UdldRecoveryAction = 'reset'
# Define UDLP recovery interval (Seconds between Udlp checking to see if it can recover):
$UdldRecoveryInt = 15
# End of Settings

# Create Hash Table for Comparison
$UdldProtoPolicyHash = @{
    RecoveryAction = $UdldRecoveryAction
    MsgInterval = $UdldRecoveryInt
}

# Initialize variables
$UdldProtoPolicy = Get-UcsFabricUdldPolicy

# Use keys in hash table to compare expected data to actual data
Foreach ($Setting in $UdldProtoPolicyHash.Keys) {
    $BadUdldProtoSettings = '' | Select RecoveryAction, MsgInterval
    If ($UdldProtoPolicy.$Setting -ne $UdldProtoPolicyHash.$Setting) {
        # Add property and value to object
        $BadUdldProtoSettings.$Setting = $UdldProtoPolicy.$Setting
    }
}

$BadUdldProtoSettings 

$Title = "UDLD Protocol Policy"
$Header =  "UDLD Protocol Policy"
$Comments = "Preferred UDLP Protocol Settings: Recovery: $UdldRecovery, Recovery Interval: $UdldRecoveryInt"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"