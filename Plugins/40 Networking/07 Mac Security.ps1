# Start of Settings
# Mac Forging (allow/deny):
$MacForging = 'deny'
# End of Settings 

$PortSecurityTable = @()
$PortSecurityPolicies = Get-UcsPortSecurityConfig

Foreach ($PortSecurityPolicy in $PortSecurityPolicies) {
    If ($PortSecurityPolicy.Forge -ne $MacForging) {
        $Details = '' | Select Policy, Location, MacForging
        $Details.Policy = $PortSecurityPolicy.Rn
        $Details.Location = $PortSecurityPolicy.Dn
        $Details.MacForging = $PortSecurityPolicy.Forge
        $PortSecurityTable += $Details
    }
}

$PortSecurityTable

$Title = "MAC Security Policy"
$Header =  "MAC Security Policy"
$Comments = "Preferred MAC Security Settings -- Forging: $MacForging"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"