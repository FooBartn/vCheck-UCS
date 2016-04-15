# Start of Settings
# End of Settings
 
# Everything in this script will run at the end of vCheck
If ($UcsConnection) {
    Disconnect-Ucs -Ucs $UcsConnection
}

$Title = "Disconnecting from UCS"
$Header = "Disconnects from UCS"
$Comments = "Disconnect plugin"
$Display = "None"
$Author = "Joshua Barton, Alan Renouf"
$PluginVersion = 1.1
$PluginCategory = "vSphere"
