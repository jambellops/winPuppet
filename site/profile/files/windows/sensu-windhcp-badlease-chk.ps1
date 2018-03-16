###########################################################
# Report-DHCPBadLeases
#
# Usage:
#   Report-DHCPBadLeases.ps1 -Warning <VALUE> -Critical <VALUE>
#
# Author:  James Bellagio
# Adapted from check_dhcp_scopes.ps1 by Elliot Anderson <elliot.a@gmail.com>
# License: MIT
############################################################

Param (
    [ValidateRange(0,100)][Int]
    # Setting Variable to 5 indicates a 10% failure with Bad Leases
    $Warning = 10,

    [ValidateRange(0,100)][Int]
    # setting Variable to 20 indicates a 30% failure with Bad Leases
    $Critical = 30

)

$Message = ""

$IsWarning  = 0
$IsCritical = 0

$ActiveScopes = Get-DhcpServerv4Scope | Where { $_.State -eq 'Active' }

if ($ActiveScopes) {
    $ActiveScopes | Foreach {
        $Scope = $_

        $Stats = Get-DhcpServerv4ScopeStatistics $Scope.ScopeId
        $BadScopLeas = Get-DhcpServerv4Lease $Scope.ScopeId -BadLeases
        $numbad = $BadScopLeas.Count
        $Free = [Int] $Stats.Free
        $InUse = [Int] $Stats.InUse

        $TotalAddresses = $Free + $InUse

        # BadScopLeas count plus 1 ensures no irrational evaluation
        switch (100*$numBad/($InUse+1)) {
            # result of the ratio of in-use IP addresses to the number of bad leases less than five indicates 20% of used addresses are bad
            #
            {$_ -gt $Critical} { $IsCritical = $IsCritical + 1
                $Message += "$($Scope.Name) is Critical ($InUse used, and $numBad IP's unavailable due to Bad Leases)`n"
            ; break}
            # result of ratio of in-use IP addresses to number of bad leases less than 20 indicates five percent of the used addresses are bad
            {$_ -ge $Warning} { $IsWarning = $IsWarning + 1
                $Message += "$($Scope.Name) is Warning ($InUse used, and $numBad IP's unavailable due to Bad Leases)`n"
            }
        }


    }
}

if ($Message) {
    Write-Output $Message
}

if ($IsCritical -gt 0) {
 exit 2
 }
if ($IsWarning -gt 0) {
 exit 1
 }

Write-Output ("{0} Scopes Ok" -f $ActiveScopes.Count)


exit 0
