# Start of Settings
# Standard Priority Flow Control setting (auto/on).
$PriorityFlowCtrl = 'auto'
# Standard Send Flow Control setting (on/off). The Receive value must be the same upstream for it to function:
$SendFlowCtrl = 'on'
# Standard Receive Flow Control setting (on/off). The Send value must be the same upstream for it to function:
$ReceiveFlowCtrl = 'on'
# End of Settings 

# Create Hash Table for Comparison
$PfcSettingsHashTable = @{
    Prio = $PriorityFlowCtrl
    Snd = $SendFlowCtrl
    Rcv = $ReceiveFlowCtrl
}

# Initialize variables
$FlowCtrlTable = @()

# Check each uplink port
Foreach ($UplinkPort in $UplinkPorts) {
    $FlowCtrlPolicy = Get-UcsFlowctrlItem -Name $UplinkPort.FlowCtrlPolicy
    $Details = '' | Select SwitchId, Port, Name, Prio, Snd, Rcv
    # Use keys in hash table to compare expected data to actual data
    Foreach ($Setting in $PfcSettingsHashTable.Keys) {
        # If the actual value is not equal to the expected value
        If ($FlowCtrlPolicy.$Setting -ne $PfcSettingsHashTable.$Setting) {
            $Details.$Setting = $FlowCtrlPolicy.$Setting
        }
    }
    # If detail object is not null, define port and add it to the array
    If ($Details) {
        $Details.SwitchId = $UplinkPort.SwitchId
        $Details.Port = $UplinkPort.Rn
        $Details.Name = $FlowCtrlPolicy.Name
        $FlowCtrlTable += $Details
    }
}

$FlowCtrlTable

$Title = "Uplink Flow Control"
$Header =  "Uplink Flow Control"
$Comments = "Preferred Flow Control Settings -- Priority Flow Control: $PriorityFlowCtrl, Send: $SendFlowCtrl, Receive: $ReceiveFlowCtrl"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"