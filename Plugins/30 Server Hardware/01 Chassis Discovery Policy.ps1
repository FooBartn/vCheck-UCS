# Start of Settings
# Minimum number of uplinks required to discover Chassis/FEX(1/2/4/8/platform-max):
$MinimumUplinksRequired = '4'
# Link aggregation preference (none/port-channel)
$LinkAggregation = 'port-channel'
# End of Settings

# Create Hash Table for Comparison
$DiscSettingsHashTable = @{
    Action = $MinimumUplinksRequired
    LinkAggregationPref = $LinkAggregation
}

# Initialize variables
$UcsChassisDiscPolicy = Get-UcsChassisDiscoveryPolicy

# Use keys in hash table to compare expected data to actual data
Foreach ($Setting in $DiscSettingsHashTable.Keys) {
    $BadDiscSettings = '' | Select Action, LinkAggregationPref
    If ($UcsChassisDiscPolicy.$Setting -ne $DiscSettingsHashTable.$Setting) {
        # Add property and value to object
        $BadDiscSettings.$Setting = $UcsChassisDiscPolicy.$Setting
    }
}

$BadDiscSettings

$Title = "Chassis/FEX Discovery Policy"
$Header =  "Chassis/FEX Discovery Policy"
$Comments = "Preferred Chassis/FEX Discovery Policy Settings -- Minimum Uplinks Required: $MinimumUplinksRequired, Link Aggregation (Grouping): $LinkAggregation"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"