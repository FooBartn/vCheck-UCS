# Start of Settings
# End of Settings

$DefaultUuidSchema = '0000-000000000001'
$DefaultMacSchema = '00:25:B5:00:00:00'
$DefaultWwnSchema = '20:00:00:25:B5:00:00:00'

$script:PoolSchemaInfoTable = @()

function Get-PoolSchemaInfo ($PoolBlocks, $MatchSchema) {
    Foreach ($PoolBlock in $PoolBlocks) {
        $Details = '' | Select-Object Location, From, To
        
        If ($PoolBlock.From -eq $MatchSchema) {
            $PoolDn = $PoolBlock.Dn
            $PoolDn -Match "[^/]+$" > $Null
            $PoolDn = $PoolDn.Replace($Matches[0],'')
            $PoolDn = $PoolDn.SubString(0,$PoolDn.Length-1)
            
            $Details.Location = $PoolDn
            $Details.To = $PoolBlock.To
            $Details.From = $PoolBlock.From
            $script:PoolSchemaInfoTable += $Details
        }
    }
}

# Call function for details	
Get-PoolSchemaInfo $UuidBlocks $DefaultUuidSchema
Get-PoolSchemaInfo $MacBlocks $DefaultMacSchema
Get-PoolSchemaInfo $WwnBlocks $DefaultWwnSchema

# Output PSObject back to vCheck
$script:PoolSchemaInfoTable

$Title = "UCS Default Pool Schema Report"
$Header =  "UCS Default Pool Schema Report"
$Comments = "Pools should not use the default schema if at all possible"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"
