﻿$ErrorActionPreference = "Stop"
Configuration WebJEADeployment {

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    #Import-DSCResource -ModuleName WebAdministrationDSC
    Import-DSCResource -ModuleName xWebAdministration
    Import-DSCResource -ModuleName xXMLConfigFile
    Import-DscResource -ModuleName cUserRightsAssignment

    Node $AllNodes.where{$_.role -eq "WebJEAServer"}.nodename {

        #Install Necessary Windows Features
        $WFs = @("Web-WebServer","Web-Default-Doc","Web-Http-Errors","Web-Static-Content","Web-IP-Security","Web-Security","Web-Windows-Auth","Web-Net-Ext45","Web-Asp-Net45","NET-Framework-45-Core","NET-Framework-45-ASPNET","Web-Stat-Compression","Web-Dyn-Compression","Web-HTTP-Redirect")
        foreach ($WF in $WFs) {
            WindowsFeature "WF_$WF" {
                Ensure = 'Present'
                Name = $WF
            }
        }

        #build app pool
        xWebAppPool "WebJEA_IISAppPool" {
            Name = $node.WebAppPoolName
            Ensure = 'Present'
            State = 'Started'
            autoStart = $true
            managedPipelineMode = 'Integrated'
            managedRuntimeVersion = 'v4.0'
            identityType = 'SpecificUser'
####1/3
            loadUserProfile = $true #this is necessary to be able to create remote pssessions and import them
        }

####2/3
        #this is how we use the GMSA without specifying a PW we don't know.  If using a regular user account, disable this and use the built-in credential support in xWebAppPool
        Script ChangeAppPoolIdentity {
            GetScript = { return @{ AppPoolName = "$($using:Node.WebAppPoolName)" }}
            TestScript = {
                import-module webadministration -verbose:$false
                $pool = get-item("IIS:\AppPools\$($using:Node.WebAppPoolName)")
                return $pool.processModel.userName -eq $using:Node.AppPoolUserName
            }
            SetScript = {
                import-module webadministration -verbose:$false

                $pool = get-item("IIS:\AppPools\$($using:Node.WebAppPoolName)");

                $pool.processModel.identityType = [String]("SpecificUser");
                $pool.processModel.userName = [String]($using:Node.AppPoolUserName)
                $pool.processModel.password = [String]($using:Node.AppPoolPassword)

                $pool | Set-Item
            }
            DependsOn = "[xWebAppPool]WebJEA_IISAppPool"
        }


        #add webjea content
        File WebJEA_WebContent {
            Ensure  = "Present"
            SourcePath = $node.WebJEASourceFolder + "\site"
            DestinationPath = $node.WebJEAIISFolder
            Recurse = $true
            Type = "Directory"
			MatchSource = $true #always copy files to ensure accurate
			Checksum = "SHA-256"
        }

        #build webjea web app subdirectory
        xWebApplication "WebJEA_IISWebApp" {
            Website = 'Default Web Site'
            Name = $node.WebJEAIISURI
            WebAppPool = $node.WebAppPoolName
            PhysicalPath = $node.WebJEAIISFolder
            AuthenticationInfo = MSFT_xWebApplicationAuthenticationInformation {
                Anonymous = $false
                Basic = $false
                Digest = $false
                Windows = $true
            }
            PreloadEnabled = $true
            ServiceAutoStartEnabled = $true
            SslFlags = @('ssl')

            DependsOn='[WindowsFeature]WF_Web-WebServer'
        }




        #configure SSL
        xWebsite "DefaultWeb" {
            Ensure = "Present"
            Name = "Default Web Site"
            State = "Started"
            BindingInfo = @(MSFT_xWebBindingInformation {
                Protocol = 'https'
                Port = '443'
                CertificateStoreName = 'MY'
                CertificateThumbprint = $node.CertThumbprint
                HostName = $node.machinefqdn
                IPAddress = '*'
                SSLFlags = '1'
            }#;
            # MSFT_xWebBindingInformation {
            #     Protocol = 'https'
            #     Port = '443'
            #     CertificateStoreName = 'MY'
            #     CertificateThumbprint = $node.CertThumbprint
            #     HostName = $node.nodename
            #     IPAddress = '*'
            #     SSLFlags = '1'
            # };
            #MSFT_xWebBindingInformation {
            #     Protocol = 'http'
            #     Port = '80'
            #     HostName = $null
            #     IPAddress = '*'
            # }
            )
            DependsOn=@('[WindowsFeature]WF_Web-WebServer','[File]WebJEA_WebContent')
        }


        #set json config location in web.config
        XMLConfigFile "WebJEAConfig" {
            Ensure = 'Present'
            ConfigPath = "$($node.WebJEAIISFolder)\web.config"
            XPath = "/configuration/applicationSettings/WebJEA.My.MySettings/setting[@name='configfile']"
            isElementTextValue = $true
            Name = "value"
            Value = $node.WebJEAConfigPath
            DependsOn=@('[File]WebJEA_WebContent','[xWebsite]DefaultWeb')
        }

        #set nlog log location in nlog.config in iis site
        XMLConfigFile "WebJEA_NLOGFile" {
            Ensure = 'Present'
            ConfigPath = "$($node.WebJEAIISFolder)\nlog.config"
            XPath = "/nlog/targets/target[@name='file']/target"
            isAttribute = $true
            Name = "fileName"
            Value = $node.WebJEA_Nlog_LogFile
            DependsOn=@('[File]WebJEA_WebContent')
        }
        XMLConfigFile "WebJEA_NLOGUsageFile" {
            Ensure = 'Present'
            ConfigPath = "$($node.WebJEAIISFolder)\nlog.config"
            XPath = "/nlog/targets/target[@name='fileSummary']/target"
            isAttribute = $true
            Name = "fileName"
            Value = $node.WebJEA_Nlog_UsageFile
            DependsOn=@('[File]WebJEA_WebContent')
        }

        #assign permissions to scripts folder?

        #Configure Default Web Site to support SSL

####3/3
        #add to logon as service
        cUserRight WebJEA_Batch {
            ensure = 'Present'
            constant = 'SeServiceLogonRight'
            principal = 'IIS APPPOOL\' + $node.AppPoolPoolName
            dependson = @('[xWebAppPool]WebJEA_IISAppPool')
        }

        #add gmsa to iusrs
        Group WebJEA_IISIUSRS {
            GroupName = 'IIS_IUSRS'
            MembersToInclude = $node.AppPoolUserName
            Ensure = 'Present'
        }


        #apppool timeout in webconfig

        #add starter scripts
        File WebJEA_ScriptsContent {
            Ensure  = "Present"
            SourcePath = $node.WebJEASourceFolder + '\StarterFiles'
            DestinationPath = $node.WebJEAScriptsFolder
            Recurse = $true
            Type = "Directory"
			MatchSource = $true #always copy files to ensure accurate
			Checksum = "SHA-256"
        }


    } #/WebJEAServer


}

