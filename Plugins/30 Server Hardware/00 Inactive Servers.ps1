# Start of Settings
# End of Settings 

$InactiveServerTable = @()
$InactiveServers = @($Blades | Where {$_.OperPower -ne "on" -OR $_.OperState -eq 'unassociated'})
$InactiveServers += @($RackUnits | Where {$_.OperPower -ne 'on' -OR $_.OperState -eq 'unassociated'})

Foreach ($InactiveServer in $InactiveServers) {
	$Details = "" | Select-Object Model, Location, Serial, PowerState, Association
	$Details.Model = $InactiveServer.Model
    $Details.Location = $InactiveServer.Dn
    $Details.Serial = $InactiveServer.Serial
    $Details.PowerState = $InactiveServer.OperPower
    $Details.Association = $InactiveServer.OperState

	$InactiveServerTable += $Details
}

$InactiveServerTable

$Title = "Inactive Server Hardware"
$Header =  "Inactive Server Hardware"
$Comments = "Servers that are either powered off or unassociated."
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"

