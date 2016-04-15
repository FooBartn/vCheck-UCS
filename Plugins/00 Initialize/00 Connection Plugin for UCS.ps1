$Title = "Connection settings for UCS"
$Author = "Joshua Barton, Alan Renouf"
$PluginVersion = 1.1
$Header = "Connection Settings"
$Comments = "Connection Plugin for connecting to Cisco UCS"
$Display = "List"
$PluginCategory = "UCS"

# Start of Settings
# Please Specify the hostname or IP address of the UCS Domain to connect to:
$UcsDomain = "192.168.0.0"
# End of Settings

# Setup plugin-specific language table
$pLang = DATA {
   ConvertFrom-StringData @'
      loadModFail = Unable to load UCS Powertool Module. Please verify that it has been installed.
      loadModSuccess = Successfully loaded Cisco UCS PowerTool
      connOpen  = Connecting to UCS Domain
      connError = Unable to connect to UCS Domain, please verify address and credentials
      collectDomain = Collecting UCS Domain Status
      collectSp = Collecting Service Profile Objects
      collectSpTemplate = Collecting Service Profile Template Objects
      collectBlades = Collecting Blade Objects
      collectRackUnits = Collecting RackUnit Objects
      collectFi = Collecting Fabric Interconnect Objects
      collectPortLic = Collecting Port License Objects
      collectFiEth = Collecting FI Ethernet Port Objects
      collectFiSan = Collecting FI SAN Port Objects
      collectChassis = Collecting Chassis Objects
      collectFaults = Collecting Fault Objects
      collectFirmware = Collecting Infrastructure Firmware Object 
      collectKvm = Collecting KVM Management IP Objects
      collectUuid = Collecting UUID Objects
      collectMac = Collecting MAC Objects
      collectWwnBlock = Collecting WWN Block Objects
      collectWwnnPool = Collecting WWNN Pool Objects
      collectWwpnPool = Collecting WWPN Pool Objects
      collectServerPool = Collecting Server Pool Objects
      collectQos = Collecting QoS Objects
      collectDns = Collecting DNS Server Objects
      collectNtp = Collecting NTP Server Objects
      collectTimezone = Collecting Time Zone Objects
      collectStatPol = Collecting Statistic Policy Objects
      
'@
}
# Override the default (en) if it exists in lang directory
Import-LocalizedData -BaseDirectory ($ScriptPath + "\lang") -BindingVariable pLang -ErrorAction SilentlyContinue

# Load UCS Powertool Module 
If (!(Get-Module -name CiscoUcsPS -ErrorAction SilentlyContinue)) {
    Import-Module CiscoUcsPs
    
    If (!(Get-Module -name CiscoUcsPS -ErrorAction SilentlyContinue)) {
		Write-Error $pLang.loadModFailed
		Throw
    } Else {
        Write-CustomOut $pLang.LoadModSuccess
    }
}

# Clear Ucs Connections
Disconnect-Ucs

# Try connecting to specified domain
Try {
    $UcsConnection = Connect-Ucs $UcsDomain -ErrorAction Stop
} Catch {
    Write-Error $pLang.connError
} Finally {
    If ($UcsConnection) {
        Write-CustomOut $pLang.connOpen
    }
}

Write-CustomOut $pLang.collectDomain
$DomStatus = Get-UcsStatus
Write-CustomOut $pLang.collectSp
$SvcProfiles = Get-UcsServiceProfile -Type instance | Sort Name
Write-CustomOut $plang.collectSpTemplate
$SvcProfileTempls = Get-UcsServiceProfile | Where-object {$_.UuidSuffix -eq '0000-000000000000'} | Sort Name
Write-CustomOut $pLang.collectBlades
$Blades = Get-UcsBlade | Sort Name
Write-CustomOut $pLang.collectRackUnits
$RackUnits = Get-UcsRackUnit | Sort Name
Write-CustomOut $pLang.collectFi
$FabricInterconnects = Get-UcsNetworkElement | Sort Name
Write-CustomOut $pLang.collectPortLic
$APortLicenses = Get-UcsLicense | Where {$_.Scope -eq 'A'}
$BPortLicenses = Get-UcsLicense | Where {$_.Scope -eq 'B'}
Write-CustomOut $pLang.collectFiEth
$UplinkPorts = Get-UcsUplinkPort | Sort Rn
$UplinkPortChannels = Get-UcsUplinkPortChannel
Write-CustomOut $pLang.collectFiSan
$FcUplinkPorts = Get-UcsFcUplinkPort | Sort Rn
$FcUplinkPortChannels = Get-UcsUplinkPortChannel
Write-CustomOut $pLang.collectChassis
$Chassis = Get-UcsChassis | Sort Rn
Write-CustomOut $pLang.collectFaults
$Faults = Get-UcsFault | Sort Severity -Descending
Write-CustomOut $pLang.collectFirmware
$Firmware = Get-UcsFirmwareRunning
Write-CustomOut $pLang.collectKvm
$MgmtIpBlocks = @(Get-UcsIpPoolBlock | Where {$_.Dn -notlike '*iscsi*'})
$MgmtIpAddrs = @(Get-UcsIpPoolAddr)
Write-CustomOut $pLang.collectUuid
$UuidBlocks = @(Get-UcsUuidSuffixBlock) 
$UuidPools = @(Get-UcsUuidSuffixPool | Where {$_.Size -ne 0})
Write-CustomOut $pLang.collectMac
$MacBlocks = @(Get-UcsMacMemberBlock)
$MacPools = @(Get-UcsMacPool | Where {$_.Size -ne 0})
Write-CustomOut $pLang.collectWwnBlock
$WwnBlocks = @(Get-UcsWwnMemberBlock)
Write-CustomOut $pLang.collectWwnnPool
$WwnnPools = @(Get-UcsWwnPool |  Where {$_.Purpose -eq 'node-wwn-assignment' -AND $_.Size -ne 0})
#$WwnnAddrs = Get-UcsAdaptorHostFcIf | Select NodeWwn -Unique | Where-Object {$_.NodeWwn -ne '00:00:00:00:00:00:00:00'}
Write-CustomOut $pLang.collectWwpnPool
$WwpnPools = @(Get-UcsWwnPool | Where {$_.Purpose -eq 'port-wwn-assignment'-AND $_.Size -ne 0})
#$WwpnAddrs = Get-UcsAdaptorHostFcIf | Select Wwn -Unique | Where-Object {$_.NodeWwn -ne '00:00:00:00:00:00:00:00'}
Write-CustomOut $pLang.collectServerPool
$ServerPools = Get-UcsServerPool
$ServerPoolAssgns = Get-UcsServerPoolAssignment           
Write-CustomOut $pLang.collectQos
$QosPolicies = Get-UcsQosPolicy
$QosClasses = Get-UcsQosClass
Write-CustomOut $pLang.collectDns
$DnsServers = Get-UcsDnsServer
Write-CustomOut $pLang.collectNtp
$NtpServers = Get-UcsNtpServer
Write-CustomOut $pLang.collectTimezone
$UcsTimezone = (Get-UcsTimeZone).OperTimezone
Write-CustomOut $pLang.collectStatPol
$StatCollPolicy = Get-UcsCollectionPolicy