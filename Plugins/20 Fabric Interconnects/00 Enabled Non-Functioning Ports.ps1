# Start of Settings
# End of Settings 

$NonFunctionPortsTable = @()
$NonFunctioningPorts = @()
$NonFunctioningPorts = $UplinkPorts | Where {$_.OperState -ne 'up' -AND $_.AdminState -eq 'enabled'}
$NonFunctioningPorts += $UplinkFcPorts | Where {$_.OperState -ne 'up' -AND $_.AdminState -eq 'enabled'}

Foreach ($NonFunctioningPort in $NonFunctioningPorts) {
	$Details = "" | Select-Object FI, Slot, Port, Role
	$Details.FI = $NonFunctioningPort.SwitchId
    $Details.Slot = $NonFunctioningPort.SlotId
	[int]$Details.Port = $NonFunctioningPort.PortId
	$Details.Role = $NonFunctioningPort.IfRole

	$UcsFiTable += $Details
}

$NonFunctionPortsTable | Sort FI, Slot, Port

$Title = "Enabled Non-Functioning Ports"
$Header =  "Enabled Non-Functioning Ports"
$Comments = "Ports that are administratively enabled but not functioning"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"