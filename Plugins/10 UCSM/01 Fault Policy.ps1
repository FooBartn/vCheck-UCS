$Title = "UCS Fault Policy"
$Header =  "UCS Fault Policy"
$Comments = "Fault policy settings outside of the set preferred values"
$Display = "List"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"


# Start of Settings
# Do you want to retain cleared faults?
$RetainClearedFaults = $True
# Minimum fault retention frequency (forever, days, hours, minutes, seconds):
$MinRetentionFrequency = 'days'
# Duration pertaining to retention frequency (ie, '7' days):
[int]$MinRetentionValue = 7
# End of Settings

Function Compare-Value ($CurrentValue,$CompareType,$MatchingValue)
{
    Switch ($CompareType)
    {
        'lt'
        {
            If ($CurrentValue -lt $MatchingValue)
            {
                Return $True
            }
            Else
            {
                Return $False
            } 
        }
        
        'ne'
        {
            If ($CurrentValue -ne $MatchingValue)
            {
                Return $True
            }
            Else
            {
                Return $False
            }
        }
    }
    
}

$ReportRetentionInt = $False
$FaultPolTable = New-Object -TypeName PSObject
$FaultPolicy = Get-UcsFaultPolicy
$FaultRetentionInt = $FaultPolicy.RetentionInterval

If ($FaultRetentionInt -ne 'forever')
{
    $SplitFaultRetention = $FaultRetentionInt.Split(":")
    [int]$DayRetentionValue = $SplitFaultRetention | Select -Index 0
    [int]$HourRetentionValue = $SplitFaultRetention | Select -Index 1
    [int]$MinuteRetentionValue = $SplitFaultRetention | Select -Index 2
    [int]$SecondRetentionValue = $SplitFaultRetention | Select -Index 3
}

Switch ($MinRetentionFrequency)
{
    'forever'
    {
        $ReportRetentionInt = Compare-Value $FaultRetentionInt 'ne' $MinRetentionFrequency
    }
    
    'days'
    {
        $ReportRetentionInt = Compare-Value $DayRetentionValue 'lt' $MinRetentionValue
    }
    
    'hours'
    {
        $ReportRetentionInt = Compare-Value $HourRetentionValue 'lt' $MinRetentionValue
    }
    
    'minutes'
    {
        $ReportRetentionInt = Compare-Value $MinuteRetentionValue 'lt' $MinRetentionValue
    }
    
    'seconds'
    {
        $ReportRetentionInt = Compare-Value $SecondRetentionValue 'lt' $MinRetentionValue
    }
}
        
If ($ReportRetentionInt)
{
    $FaultPolTable | Add-Member -Name "Retention Interval" -MemberType NoteProperty -Value "$DayRetentionValue Days, $HourRetentionValue Hours, $MinuteRetentionValue Minutes, $SecondRetentionValue Seconds"
}

If (Compare-Value $Fault.ClearAction 'ne' $RetainClearedFaults)
{
    $FaultPolTable | Add-Member -Name "Clear Faults Action" -MemberType NoteProperty -Value $($RetainClearedFaults)
}

$FaultPolTable