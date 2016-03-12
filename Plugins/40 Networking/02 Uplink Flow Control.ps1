# Start of Settings
# Standard Priority Flow Control setting (auto/on).
$PriorityFlowCtrl = 'auto'
# Standard Receive Flow Control setting (on/off). The Send value must be the same upstream for it to function:
$ReceiveFlowCtrl = 'on'
# Standard Send Flow Control setting (on/off). The Receive value must be the same upstream for it to function:
$SendFlowCtrl = 'on'
# End of Settings 

$FlowCtrlTable = @()

Foreach ($UplinkPort in $UplinkPorts) {
    $FlowCtrlPolicy = Get-UcsFlowctrlItem -Name $UplinkPort.FlowCtrlPolicy
    $SndFlowPolicy = $FlowCtrlPolicy.Snd
    $RcvFlowPolicy = $FlowCtrlPolicy.Rcv
    $PrioFlowPolicy = $FlowCtrlPolicy.Prio
    
    If ($PrioFlowPolicy -ne $PriorityFlowCtrl -OR $SndFlowPolicy -ne $SendFlowCtrl -OR $RcvFlowPolicy -ne $ReceiveFlowCtrl) {
        $Details = '' | Select Port, Policy, PFC, Send, Receive
        $Details.Port = $UplinkPort.Rn
        $Details.Policy = $FlowCtrlPolicy.Name
        $Details.PFC = $FlowCtrlPolicy.Prio
        $Details.Send = $FlowCtrlPolicy.Snd
        $Details.Receive = $FlowCtrlPolicy.Rcv
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