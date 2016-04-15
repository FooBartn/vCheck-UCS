$Title = "General Information"
$Header =  "General Information"
$Comments = "General details on the infrastructure"
$Display = "List"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"

# Start of Settings 
# End of Settings 


If ($DomStatus.FiALeadership -eq "primary") {
	$FabPrimary = "A"
} Else {
	$FabPrimary = "B"
}

$Info = New-Object -TypeName PSObject -Property @{
    "Number of Chassis" = (@($Chassis).Count)
    "Number of Blades" = (@($Blades).Count)
    "Number of RackUnits" = (@($RackUnits).Count)
    "Number of Templates" = (@($SvcProfileTempls).Count)
    "Number of Profiles" = (@($SvcProfiles).Count)
    "UCSM FW" = (Get-UcsFirmwareInfra).OperVersion
    "UCS Domain Name:" = $DomStatus.Name
    "Primary Interconnect" = $FabPrimary
    "HA State" = $DomStatus.HaReadiness   
}

$Info