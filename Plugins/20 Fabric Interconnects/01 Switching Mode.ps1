# Start of Settings
# What Ethernet Switching Mode do you require:
$EthernetSwitchMode = 'end-host'
# What FC Switching Mode do you require:
$FcSwitchMode = 'end-host'
# End of Settings

$UcsSwitchModeTable = @()
$UcsLanCloud = Get-UcsLanCloud
$UcsSanCloud = Get-UcsSanCloud 

If($UcsLanCloud.Mode -ne $EthernetSwitchMode) {
    $Details = '' | Select TrafficType, Mode
    $Details.TrafficType = $UcsLanCloud.Rn
    $Details.Mode = $UcsLanCloud.Mode
    $UcsSwitchModeTable += $Details    
}

If($UcsSanCloud.Mode -ne $FcSwitchMode) {
    $Details = '' | Select TrafficType, Mode
    $Details.TrafficType = $UcsSanCloud.Rn
    $Details.Mode = $UcsSanCloud.Mode
    $UcsSwitchModeTable += $Details    
}

$UcsSwitchModeTable

$Title = "Fabric Interconnect Switch Modes"
$Header =  "Fabric Interconnect Switch Modes"
$Comments = "Preferred Switch Mode Settings -- Ethernet: $EthernetSwitchMode, FC: $FcSwitchMode"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"