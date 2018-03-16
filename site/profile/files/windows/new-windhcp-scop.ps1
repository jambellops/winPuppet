$srvlistpath = Read-Host "enter path to serverlist"

$dhcpServers=Import-Csv $srvlistpath


foreach ($dhcpServer in $dhcpServers) {

    $Server = $dhcpServer.server
    $name = $dhcpserver.name
    $StartRange = $dhcpserver.StartRange
    $endRange = $dhcpserver.endRange
    $mask = $dhcpserver.mask
    $scope = $dhcpserver.scope
    $EndRangeRes = $dhcpserver.EndRangeRes
    $dnsArray = $dhcpserver.DNS1, $dhcpserver.DNS2
    $dname = $dhcpserver.dname

Invoke-Command -ComputerName $Server -ScriptBlock{ 
    param(
    $Server,
    $name,
    $StartRange,
    $endRange,
    $mask,
    $scope,
    $EndRangeRes,
    $dnsArray,
    $dname
        )
        Add-DhcpServerv4Scope -Name $Name -StartRange $StartRange -EndRange $endRange -SubnetMask $mask -ComputerName $Server -Description $Name -LeaseDuration 08:00 -State Inactive
        sleep -Seconds 5
        Add-Dhcpserverv4ExclusionRange -ScopeId $Scope -StartRange $StartRange -EndRange $EndRangeRes -ComputerName $Server
        sleep -Seconds 5
        Set-DhcpServerv4OptionValue -ScopeID $Scope -DNSServer $dnsArray -DNSDomain $dname -Router $StartRange -ComputerName $Server
       
    } -ArgumentList $Server,$name,$StartRange,$endRange,$mask,$scope,$EndRangeRes,$dnsArray,$dname
}


