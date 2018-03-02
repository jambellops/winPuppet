$YamlPath = 'C:\ProgramData\PuppetLabs\puppet\etc'
if (!(Test-Path $YamlPath)){
    New-Item -Path $YamlPath -ItemType Container
}

$Instance_Details = . $env:ProgramFiles\RightScale\RightLink\rsc.exe --rl10 cm15 index_instance_session /api/sessions/instance


#Jsonobject to PSobject
$Instance_Object = ConvertFrom-Json $Instance_Details

#establish data to be written
$Instance_ID = $Instance_Object.resource_uid
$IsInstance_Provisioned = $Instance_Object.rs_provisioned

# Api link has a property ".href" 
$Instance_ApiLink = $Instance_Object.links | Where-Object -Property rel -EQ -Value 'self'
$Instance_ApiLinkhref = $Instance_ApiLink.href

# create yaml file and add content
if (Test-Path -Path 'C:\ProgramData\PuppetLabs\puppet\etc\csr_attributes.yaml') {
	#Write-Log -message 'CSR attribute file already exists.'
	Clear-Content -Path 'C:\ProgramData\PuppetLabs\puppet\etc\csr_attributes.yaml'
	
}
else {
New-Item -Name csr_attributes.yaml -Path $YamlPath
}
Add-Content -Path 'C:\ProgramData\PuppetLabs\puppet\etc\csr_attributes.yaml' -Value 'extension_requests:'
Add-Content -Path 'C:\ProgramData\PuppetLabs\puppet\etc\csr_attributes.yaml' -Value "pp_instance_id:$Instance_ID"
Add-Content -Path 'C:\ProgramData\PuppetLabs\puppet\etc\csr_attributes.yaml' -Value "pp_provisioner:$IsInstance_Provisioned"
Add-Content -Path 'C:\ProgramData\PuppetLabs\puppet\etc\csr_attributes.yaml' -Value "pp_cloudplatform:$Instance_ApiLinkhref"
