# Start of Settings
# Define whether LACP Suspend Individual should be on (true/false):
$LacpSuspend = 'true'
# Define LACP Rate setting (normal/fast):
$LacpRate = 'normal'
# End of Settings 

$LacpPolicyTable = @()
$LacpPolicies = Get-UcsFabricLacpPolicy

Foreach ($LacpPolicy in $LacpPolicies) {
    If ($LacpPolicy.FastTimer -ne $LacpRate -OR $LacpPolicy.SuspendIndividual -ne $LacpSuspend) {
        $Details = '' | Select Policy, Location, Suspend, Rate
        $Details.Policy = $LacpPolicy.Name
        $Details.Location = $LacpPolicy.Dn
        $Details.Suspend = $LacpPolicy.SuspendIndividual
        $Details.Rate = $LacpPolicy.FastTimer
        $LacpPolicyTable += $Details
    }
}

$LacpPolicyTable

$Title = "LACP Policies"
$Header =  "LACP Policies"
$Comments = "Preferred LACP Settings -- Suspend Individual: $LacpSuspend, Rate: $LacpRate"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"