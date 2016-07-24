# Start of Settings
# At what percent usage should pools be reported
$PoolUsedLimit = 80
# End of Settings

$script:PoolBlockTable = @()

Function Get-BlockDetails ($Blocks, $Pools, $Type) {
    Foreach ($Pool in $Pools)
    {
        $PercentUsed = $Pool.Assigned * 100 / $Pool.Size
        $PoolDN = $Pool.Dn
        
        If ($PercentUsed -ge $PoolUsedLimit)
        {
            $Details = "" | Select-Object Type, Name, From, To, Total, Used, PercentUsed
            $Details.Type = $Type
            $Details.Name = $Pool.Rn
            $Details.Total = $Pool.Size
            $Details.Used = $Pool.Assigned
            $Details.PercentUsed = $PercentUsed 
            
            $ThisBlock = $Blocks | Where {$_.Dn -like "$PoolDN/*"}

            $Details.From = $ThisBlock.From
            $Details.To = $ThisBlock.To

            $script:PoolBlockTable += $Details
        }
    }
}

# Call function for details	
Get-BlockDetails $UuidBlocks $UuidPools "UUID"
Get-BlockDetails $MacBlocks $MacPools "MAC"
Get-BlockDetails $WwnBlocks $WwnnPools "WWNN"
Get-BlockDetails $WwnBlocks $WwpnPools "WWPN"

# Output PSObject back to vCheck
$script:PoolBlockTable

$Title = "High Pool Utilization"
$Header =  "UID Pools With High Utilization"
$Comments = "Pools over $PoolUsedLimit percent used"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"
