# Start of Settings
# Define whether UDLD should be enabled (enabled/disabled):
$UdldState = 'enabled'
# Define UDLD mode: (normal/aggressive):
$UdldMode = 'aggressive'
# End of Settings 

$UdldLinkPolicyTable = @()
$UdldLinkPolicies = Get-UcsFabricUdldLinkPolicy

# Create Hash Table for Comparison
$UdldLinkSettingsHashTable = @{
    AdminState = $UdldState
    Mode = $UdldMode
}


Foreach ($UdldLinkPolicy in $UdldLinkPolicies) {
    $Details = '' | Select Name, AdminState, Mode
    # Use keys in hash table to compare expected data to actual data
    Foreach ($Setting in $UdldLinkSettingsHashTable.Keys) {
        # If the actual value is not equal to the expected value
        If ($UdldLinkPolicy.$Setting -ne $UdldLinkSettingsHashTable.$Setting) {
            $Details.$Setting = $UdldLinkPolicy.$Setting
        }
    }
    # If detail object is not null, define port and add it to the array
    If ($Details) {
        $Details.Name = $UdldLinkPolicy.Name
        $UdldLinkPolicyTable += $Details
    }
}

$UdldLinkPolicyTable

$Title = "UDLD Link Policies"
$Header =  "UDLD Link Policies"
$Comments = "Preferred UDLD Link Policy Settings: State: $UdldState, Mode: $UdldMode"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"