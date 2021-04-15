param ([switch]$fast)
$ErrorActionPreference = "Stop"

$MyData = @{
    AllNodes = @(
        @{
            NodeName              = '*'
            WebAppPoolName        = 'WebJEA'
            AppPoolUserName       = 'lab\SA-Webjea$'
            AppPoolPassword       = "" #no credential data is actually password because we're using gMSAs
            #if you use a non-msa, use another method to set the apppool identity
            WebJEAIISURI          = 'WebJEA'
            WebJEAIISFolder       = 'C:\inetpub\wwwroot\webjea'
            WebJEASourceFolder    = 'C:\source'
            WebJEAScriptsFolder   = 'C:\scripts'
            WebJEAConfigPath      = 'C:\scripts\config.json' #must be in webjeascriptsfolder
            WebJEALogPath         = 'c:\scripts'
            WebJEA_Nlog_LogFile   = "c:\scripts\webjea.log"
            WebJEA_Nlog_UsageFile = "c:\scripts\webjea-usage.log"
        },
        @{
            NodeName       = 'LAB-MDS01'
            Role           = 'WebJEAServer'
            MachineFQDN    = 'LAB-MDS01.LAB.LOCAL'
            CertThumbprint = '00fc88f88d16cfb3411e3b0730c6f5c9e9cfce6f'
        }
    )
}


if (-not $fast) {
    #install necessary powershell modules
    Write-Host "Configuring Package Provider"
    Install-PackageProvider -Name nuget -MinimumVersion 2.8.5.201 -Force
    Write-Host "Trusting PSGallery"
    Set-PSRepository -Name psgallery -InstallationPolicy trusted
    #####install-module WebAdministrationDSC
    Write-Host "Installing DSC Modules"
    Install-Module xwebadministration
    Install-Module xXMLConfigFile
    Install-Module cUserRightsAssignment
}

#create the group MSA account
#add-kdsrootkey -effectivetime ((get-date).addhours(-10))
#new-ADServiceAccount -name gmsa1 -dnshostname (get-addomaincontroller).hostname -principalsallowedtoretrievemanagedpassword mgmt1
#install-adserviceaccount gmsa1
#add-adgroupmember -identity "domain1\domain admins" -members (get-adserviceaccount gmsa1).distinguishedname
#at a later time, grant gmsa1 the permissions you want.

#cd wsman::localhost\client
#Set-Item TrustedHosts * -confirm:$false -force
#restart-service winrm


Write-Host "Building Configuration"
. .\DSCConfig.inc.ps1
WebJEADeployment -ConfigurationData $MyData -verbose -OutputPath .\WebJEADeployment

Write-Host "Starting DSC"
Start-DscConfiguration -ComputerName $env:computername -Path .\WebJEADeployment -Verbose -Wait -Force
