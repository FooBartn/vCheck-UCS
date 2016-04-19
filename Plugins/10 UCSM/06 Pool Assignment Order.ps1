# Start of Settings
# At what percent usage should pools be reported
$AssignmentOrder = "sequential"
# End of Settings

$script:PoolOrderTable = @()

Function Get-PoolAssignmentOrder ($Pools, $Type) {
    Foreach ($Pool in $Pools)
    {
        $Details = "" | Select-Object Type, Name, AssignmentOrder
        
        If ($Pool.AssignmentOrder -ne $AssignmentOrder) {
            $Details.Type = $Type
            $Details.Name = $Pool.Rn
            $Details.AssignmentOrder = $Pool.AssignmentOrder
            $script:PoolOrderTable += $Details
        }
        
    }
}

# Call function for details	
Get-PoolAssignmentOrder $UuidPools "UUID"
Get-PoolAssignmentOrder $MacPools "MAC"
Get-PoolAssignmentOrder $WwnnPools "WWNN"
Get-PoolAssignmentOrder $WwpnPools "WWPN"

# Output PSObject back to vCheck
$script:PoolOrderTable

$Title = "Pool Assignment Order"
$Header =  "Pool Assignment Order"
$Comments = "Preferred Pool Assignment Order: $AssignmentOrder"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"
