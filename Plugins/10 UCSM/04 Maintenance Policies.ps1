# Start of Settings
# Define the Maintenance Policy disruption setting (user-ack/immediate/timer-automatic):
$UptimeDisruption = 'user-ack'
# End of Settings 

$MaintenancePolicyTable = @()
$MaintenancePolicies = Get-UcsMaintenancePolicy

Foreach ($MaintenancePolicy in $MaintenancePolicies) {
    If ($MaintenancePolicy.UptimeDisr -ne $UptimeDisruption) {
        $Details = '' | Select Policy, Location, UptimeDisruption
        $Details.Policy = $MaintenancePolicy.Name
        $Details.Location = $MaintenancePolicy.Dn
        $Details.UptimeDisruption = $MaintenancePolicy.UptimeDisr
        $MaintenancePolicyTable += $Details
    }
}

$MaintenancePolicyTable

$Title = "Maintenance Policies"
$Header =  "Maintenance Policies"
$Comments = "Preferred Maintenance Setting -- Uptime Disruption: $UptimeDisruption"
$Display = "Table"
$Author = "Joshua Barton"
$PluginVersion = 1.0
$PluginCategory = "UCS"