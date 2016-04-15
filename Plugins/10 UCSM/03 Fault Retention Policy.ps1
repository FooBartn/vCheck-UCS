# Start of Settings
# Minimum fault retention frequency (forever, days, hours, minutes, seconds):
$MinRetentionFrequency = 'days'
# Duration pertaining to retention frequency (ie, '7' days):
[int]$MinRetentionValue = 7
# End of Settings

$ReportRetentionInt = $False
$FaultPolTable = @()
$FaultPolicy = Get-UcsFaultPolicy
$FaultRetentionInt = $FaultPolicy.RetentionInterval

If ($FaultRetentionInt -ne 'forever') {
    $SplitFaultRetention = $FaultRetentionInt.Split(":")
    [int]$DayRetentionValue = $SplitFaultRetention | Select -Index 0
    [int]$HourRetentionValue = $SplitFaultRetention | Select -Index 1
    [int]$MinuteRetentionValue = $SplitFaultRetention | Select -Index 2
    [int]$SecondRetentionValue = $SplitFaultRetention | Select -Index 3
}

Switch ($MinRetentionFrequency) {
    'forever' {
        
        If ($FaultRetentionInt -ne $MinRetentionFrequency) {
            $ReportRetentionInt = $True
        }
    }
    
    'days' {
        If ($DayRetentionValue.CompareTo($MinRetentionValue) -eq -1) {
            $ReportRetentionInt = $True
        }
    }
    
    'hours' {
        If ($HourRetentionValue.CompareTo($MinRetentionValue) -eq -1) {
            $ReportRetentionInt = $True
        }
    }
    
    'minutes' {
        If ($MinuteRetentionValue.CompareTo($MinRetentionValue) -eq -1) {
            $ReportRetentionInt = $True
        }
    }
    
    'seconds' {
        If ($SecondRetentionValue.CompareTo($MinRetentionValue) -eq -1) {
            $ReportRetentionInt = $True
        }
    }
}
        
If ($ReportRetentionInt) {
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