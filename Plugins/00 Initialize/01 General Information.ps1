$Title = "General Information"
$Header =  "General Information"
$Comments = "General details on the infrastructure"
$Display = "List"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"

# Start of Settings 
# End of Settings 


If ($DomStatus.FiALeadership -eq "primary")
{
	$FabPrimary = "A"
	$FabSecondary = "B"
}
Else
{
	$FabPrimary = "B"
	$FabSecondary = "A"
}

$SplitRetention = ((Get-UcsFaultPolicy).RetentionInterval).Split(":")

If ($SplitRetention[0] -ne "00")
{
	$TimeSpan = "Days"
	$RetLimit = $SplitRetention[0]
} 
Else
{
	$TimeSpan = "Hours"
	$RetLimit = $SplitRetention[1]
}

[Int]$InactiveServers = (@($Blades | Where {$_.OperPower -ne "on"}).Count)
$InactiveServers += (@($RackMounts | Where {$_.OperPower -ne 'on'}).Count)

$Info = New-Object -TypeName PSObject -Property @{
    "UCS Domain Name:" = $DomStatus.Name
    "Primary Interconnect:" = $FabPrimary
    "Secondary Interconnect:" = $FabSecondary
    "HA State:" = $DomStatus.HaReadiness
    "FI Switch Mode:" = (Get-UcsLanCloud).Mode
    "Number of Chassis:" = (@($Chassis).Count)
    "Number of Blades:" = (@($Blades).Count)
    "Number of RackUnits" = (@($RackUnits).Count)
    "Number of Templates:" = (@($SvcProfTmpls).Count)
    "Number of Profiles:" = (@($SvcProfs).Count)
    "In-Active Servers:" = $InactiveServers
    "Faults:" = (@($Faults).Count)
    "Fault Retention Policy:" = ($RetLimit + " " + $TimeSpan)
    "UCSM FW:" = (Get-UcsFirmwareInfra).OperVersion
}

$Info