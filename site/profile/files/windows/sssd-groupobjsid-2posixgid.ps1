function Get-Uniquesid()
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false,ValueFromPipeline)]
        [System.Security.Principal.SecurityIdentifier]$sid,
        [string]$errorlog = "c:\temp\gid.txt"
    )

$groups = Get-ADGroup -SearchBase "OU=CorpSSSD,OU=Groups,OU=Managed,DC=corp,DC=uber,DC=com" -filter * | Select-Object -ExpandProperty Name

Foreach ($group in $groups)
    {
    $Groupattr = get-adgroup -Identity $group -properties ObjectSid | Select-object -ExpandProperty ObjectSid
    $groupgid =  get-adgroup -Identity $group -properties gidnumber | Select-object -ExpandProperty gidnumber
    $groupvalue = $groupattr.value
    $Numa = $groupvalue.split("-")
    $gidnumber = $Numa[7]
        If ($groupgid -eq $null) {
        Set-ADGroup -Identity $group -Replace @{gidnumber = "$gidnumber"} #-WhatIf
        } Else {
        $null 
        }
    }
}
Get-Uniquesid
