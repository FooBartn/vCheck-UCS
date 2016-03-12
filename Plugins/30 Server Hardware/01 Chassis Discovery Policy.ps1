# Start of Settings
# Minimum number of uplinks required to discover Chassis/FEX(1/2/4/8/platform-max):
$MinimumUplinksRequired = '4'
# Link aggregation preference (none/port-channel)
$LinkAggregation = 'port-channel'
# End of Settings

$UcsChassisDiscTable = @()
$UcsChassisDiscPolicy = Get-UcsChassisDiscoveryPolicy

If($UcsChassisDiscPolicy.Action -ne $MinimumUplinksRequired -OR $UcsChassisDiscPolicy.LinkAggregationPref -ne $LinkAggregation) {
    $Details = '' | Select MinimumUplinksRequired, LinkAggregation
    $Details.MinimumUplinksRequired = $UcsChassisDiscPolicy.Action
    $Details.LinkAggregation = $UcsChassisDiscPolicy.LinkAggregationPref
    $UcsChassisDiscTable += $Details    
}

$UcsChassisDiscTable

$Title = "Chassis/FEX Discovery Policy"
$Header =  "Chassis/FEX Discovery Policy"
$Comments = "Preferred Chassis/FEX Discovery Policy Settings -- Minimum Uplinks Required: $MinimumUplinksRequired, Link Aggregation (Grouping): $LinkAggregation"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"