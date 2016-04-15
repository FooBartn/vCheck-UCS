# Start of Settings
# Define protocol for sending SEL logs to remote location (ftp/tftp/scp/sftp):
$SelProtocol = 'sftp'
# Define hostname or IP for remote storage location:
$RemoteSelStorage = 'sftp.domain.org'
# Define storage path on remote location:
$RemoteSelPath = '/'
# Should server logs be cleared on backup (yes/n+1/grid):
$ClearOnBackup = 'yes'
# Define when to offload SEL logs. Use braces and choose one or more options separated by commas {log-full, on-assoc-change, on-clear, timer}:
$SelAction = {log-full}
# Interval if timer is set as a SelAction.  {1hour/2hours/4hours/8hours/24hours/1week/1month}:
$SelInterval = '1 hour'
# End of Settings

# Create Hash Table for Comparison
$SelSettingsHashTable = @{
    Proto = $SelProtocol
    Hostname = $RemoteSelStorage
    RemotePath = $RemoteSelPath
    ClearOnBackup = $ClearOnBackup
    Action = $SelAction
    Interval = $SelInterval
}

# Initialize variables
$BadSelSettings = New-Object psobject
$ActionList = ''
$UcsSelPolicy = Get-UcsSysdebugBackupBehavior

# Use keys in hash table to compare expected data to actual data
Foreach ($Setting in $SelSettingsHashTable.Keys) {
    # If the actual value is not equal to the expected value -->
    If ($UcsSelPolicy.$Setting -ne $SelSettingsHashTable.$Setting) {
        # Action is an array, so we're turning it into a comma delimited string for output
        If ($Setting -eq 'Action') {
            Foreach ($SettingProperty in $UcsSelPolicy.$Setting) {
                $ActionList += "$SettingProperty, "
            }
            # Add $ActionList minus the last , and space value
            $BadSelSettings | Add-Member -MemberType NoteProperty -Name $Setting -Value $ActionList.SubString(0,($ActionList.Length -2))
        } Else {
            # Add property and value to $BadSelSettings object
            $BadSelSettings | Add-Member -MemberType NoteProperty -Name $Setting -Value $UcsSelPolicy.$Setting    
        }        
    }
}

$BadSelSettings

$Title = "SEL Policy"
$Header =  "SEL Policy"
$Comments = "Preferred SEL Policy Setting -- Protocol: $SelProtocol, Hostname: $RemoteSelStorage, Remote Path: $RemoteSelPath, Clear on Backup: $ClearOnBackup, SEL Actions: $SelAction, Interval: $SelInterval"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"