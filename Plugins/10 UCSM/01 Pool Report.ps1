# Start of Settings
# At what percent usage should pools be reported
$PoolUsedLimit = 80
# End of Settings

$script:PoolBlockTable = @()

Function Get-BlockDetails ($Blocks, $Pools, $Type) {
    Foreach ($Pool in $Pools)
    {
        $PercentUsed = $Pool.Assigned * 100 / $Pool.Size
        
        If ($PercentUsed -ge $PoolUsedLimit)
        {
            $Details = "" | Select-Object Type, Name, From, To, Total, Used, PercentUsed
            $Details.Type = $Type
            $Details.Name = $Pool.Rn
            $Details.Total = $Pool.Size
            $Details.Used = $Pool.Assigned
            $Details.PercentUsed = $PercentUsed 
            
            Foreach ($Block in $Blocks)
            {
                $ThisBlock = $Blocks | Where {$_.Dn -eq "$($Pool.Dn)/$($Block.Rn)"}
            }

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

$Title = "UCS Pool Report"
$Header =  "Pools over $PoolUsedLimit percent used"
$Comments = "Mac, WWPN, WWNN, UUID"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"
