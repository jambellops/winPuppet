$computerfilepath = Read-Host -Prompt "enter path of computernames file"


$Computers = Get-Content $computerfilepath
$Source = Read-Host -Prompt "enter path of source files"
$Destination = Read-Host -Prompt "enter path of destination files" # example: "C$\installs\"

foreach ($Computers in $Computers) {
if ((Test-Path -Path \\$Computers\$Destination)) {
Copy-Item $Source -Destination \\$Computers\$Destination -Recurse
} else {
"\\$Computer\$Destination is not reachable or does not exsist"
}
} 
