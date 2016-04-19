# Start of Settings
# Standard Priority Flow Control setting (auto/on).
$PriorityFlowCtrl = 'auto'
# Standard Send Flow Control setting (on/off). The Receive value must be the same upstream for it to function:
$SendFlowCtrl = 'on'
# Standard Receive Flow Control setting (on/off). The Send value must be the same upstream for it to function:
$ReceiveFlowCtrl = 'on'
# End of Settings 

# Create Hash Table for Comparison
$PfcPortSettingsHashTable = @{
    Prio = $PriorityFlowCtrl
    Snd = $SendFlowCtrl
    Rcv = $ReceiveFlowCtrl
}

# Initialize variables
$script:PortFlowCtrlTable = @()

function Get-PfcSetting {
    param (
        # Port or Port Channel Uplink Object
        [Parameter(Mandatory = $True)]
        [array]
        $UplinkObjects
    )
    
    Foreach ($UplinkObject in $UplinkObjects) {
        $FlowCtrlPolicy = Get-UcsFlowctrlItem -Name $UplinkObject.FlowCtrlPolicy
        $Details = '' | Select SwitchId, Port, Name, Prio, Snd, Rcv
        # Use keys in hash table to compare expected data to actual data
        Foreach ($Setting in $PfcPortSettingsHashTable.Keys) {
            # If the actual value is not equal to the expected value
            If ($FlowCtrlPolicy.$Setting -ne $PfcPortSettingsHashTable.$Setting) {
                $Details.$Setting = $FlowCtrlPolicy.$Setting
            }
        }
        # If detail object is not null, define port and add it to the array
        If ($Details) {
            $Details.SwitchId = $UplinkObject.SwitchId
            $Details.Port = $UplinkObject.Rn
            $Details.Name = $FlowCtrlPolicy.Name
            $script:PortFlowCtrlTable += $Details
        }
    }
}

Get-PfcSetting $UplinkPorts
Get-PfcSetting $UplinkPortChannels


$script:PortFlowCtrlTable

$Title = "Port Uplink Flow Control"
$Header =  "Port Uplink Flow Control"
$Comments = "Preferred Port Flow Control Settings -- Priority Flow Control: $PriorityFlowCtrl, Send: $SendFlowCtrl, Receive: $ReceiveFlowCtrl"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"