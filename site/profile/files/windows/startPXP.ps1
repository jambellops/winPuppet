
PARAM ( 
    [bool]$Runit = $false,
    [bool]$DCs = $false,
    [string]$NodeList
)

Function StartPXP{
    Process{
        Try{
            if ($Input) {
                $SvrPool = Get-Content $NodeList
            } else {
                if (!$DCs) {
                    $SB = "OU=Domain Controllers,DC=corp,DC=uber,DC=com"
                } else {
                    $SB = "OU=Servers,OU=Computers,OU=Managed,DC=corp,DC=uber,DC=com"            
                }
                $SvrPool = Get-ADComputer -filter {name -like "*" -and enabled -eq $true -and operatingSystem -like "*Windows*"} -SearchBase $SB -Properties operatingSystem |
                    select -ExpandProperty DNSHostname            
            }

            foreach ($SvrName in $SvrPool) {
                echo $SvrName
                if ($runit) {
                    Set-Service -ComputerName $SvrName -Name pxp-agent -status Running -PassThru
                }
            }

    End{
        If($?){ # only execute if the function was successful.
            Write-Host "Completed StartPXP function."
        }
    }
 }

#----------------[ Main Execution ]----------------------------------------------------

# Script Execution goes here

Function Main{
    Process{
            StartPXP | Out-File -Append .\Results.txt
    } End{
        If($?){ # only execute if the function was successful.
            Write-Host "Completed main function."
        }
    }
}


# Invoke main function
Main
