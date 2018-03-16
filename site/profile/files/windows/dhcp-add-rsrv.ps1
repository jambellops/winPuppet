$ScopeName = read-host -Prompt "Type in scope name" 
$DataPath = read-host -prompt "Type in data file path" 
 
$DhcpScope = Get-DhcpServerv4Scope | where-object{ $_.name.tolower() -eq $ScopeName.ToLower() } 
$ResList = import-csv -Path $dataPath -Delimiter "," 
 
foreach( $r in $reslist ) 
{ 
    if ( $r.'MAC address' -eq $null ) { continue } 
    $m = ($r.'MAC address').replace( ":", "-") 
    Add-DhcpServerv4Reservation -ScopeId $DhcpScope.ScopeId -Description $r.'Description' -IPAddress $r.'IP address' -Name $r.'Hostname' -ClientId $m -Type Dhcp 
} 
