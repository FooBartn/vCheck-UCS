# Start of Settings
# Define power redundancy setting (non-redundant/n+1/grid):
$PowerRedundancy = 'grid'
# End of Settings

$UcsPowerPolicyTable = @()
$UcsPowerPolicy = Get-UcsPowerControlPolicy

If($UcsPowerPolicy.Redundancy -ne $PowerRedundancy) {
    $Details = '' | Select Name, Redundancy
    $Details.Name = $UcsPowerPolicy.Name
    $Details.Redundancy = $UcsPowerPolicy.Redundancy
    $UcsPowerPolicyTable += $Details    
}

$UcsPowerPolicyTable

$Title = "Power Policy"
$Header =  "Power Policy"
$Comments = "Preferred Power Policy Setting -- Redundancy: $PowerRedundancy"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"