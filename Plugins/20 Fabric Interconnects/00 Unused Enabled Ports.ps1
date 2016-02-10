# Start of Settings
# End of Settings 

$UcsFiTable = @()
$EthPorts = $EthPorts | Where {$_.OperState -ne 'up' -AND $_.AdminState -eq 'enabled'}

Foreach ($Port in $EthPorts) {
	$Details = "" | Select-Object FI, Slot, Port, Role
	$Details.FI = $Port.SwitchId
    $Details.Slot = $Port.SlotId
	[int]$Details.Port = $Port.PortId
	$Details.Role = $Port.IfRole

	$UcsFiTable += $Details
}

$UcsFiTable | Sort SwitchId, Slot, Port

$Title = "Enabled Non-Functioning Ports"
$Header =  "Enabled Non-Functioning Ports"
$Comments = "Ports that are administratively enabled but not functioning"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 0.1
$PluginCategory = "UCS"