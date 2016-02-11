# Start of Settings
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
$FaultPolDetails = New-Object -TypeName PSObject
$FaultPolTable = @()
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
    $Details = '' | Select Days, Hours, Minutes, Seconds
    $Details.Days = $DayRetentionValue
    $Details.Hours = $HourRetentionValue
    $Details.Minutes = $MinuteRetentionValue
    $Details.Seconds = $SecondRetentionValue

    $FaultPolTable += $Details
}

$FaultPolTable

$Title = "UCS Fault Retention Policy"
$Header =  "UCS Fault Retention Policy"
$Comments = "Fault retention policy lower than $MinRetentionValue $MinRetentionFrequency"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"