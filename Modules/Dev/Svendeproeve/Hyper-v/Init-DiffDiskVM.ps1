function Create-Credentials {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]
        $userName
    )
    # Asking for credentials:
   
    if (-Not $userName) {
        Write-Host "Insert Username: " -ForegroundColor "$TxtColour" -NoNewline
        [string]$userName = Read-Host
    }
    
    Write-Host "Type in password: " -ForegroundColor "$TxtColour" -NoNewline
    [securestring]$userPassword = Read-Host -AsSecureString
    #Create the $CredObject
    [pscredential]$script:credObject = New-Object System.Management.Automation.PSCredential ($userName, $userPassword)

}
function Init-DiffVM {
    <# No parameters are needed this is just to make it easy to create new VM's 
    I really like using functions instead of plain Scripting. Gives better overview
    
    #>
    [CmdletBinding()]
    param ()
    
    begin {
        #Create the variables used in the Script
        #Variables Script

        #Domain Dependence
        $DomainToJoin = 'LKKORP.LOCAL';
        $OuPath = 'OU=VM,OU=Servers,OU=Computers,OU=LKCorp,DC=LKKORP,DC=local"'

        #Credential Creation for Domain Join
        $CredObject = Create-Credentials -userName "$($DomainToJoin.Split('.')[0])\SA-MDT"

        #VM NAME
        Write-Host -Object 'VM NAME: ' -ForegroundColor "$TxtColour" -NoNewline;
        $VMName = Read-Host;
        $VmName = "$($DomainToJoin.Split('.')[0])-$VMName";
        
        #Ip address
        Write-Host -Object 'IP address: ' -ForegroundColor "$TxtColour" -NoNewline;
        [System.Net.IPAddress]$IP = Read-Host;
        $DNS = 10.0.10.100 #Standard
        [System.Net.IPAddress]$DefaultGateway = "10.0.$($IP.ToString().split('.')[2]).1";
        $CIDR = '24'
        $NetworkCard = (Get-NetAdapter | Where-Object { $_.Name -eq 'Ethernet' }).InterfaceAlias

    }
    
    process {
        Write-Host -Object "*************************************************************************" -ForegroundColor $ConfirmColour
        Write-Host -Object "*   VMNAME: $VMName" -ForegroundColor $ConfirmColour
        Write-Host -Object "*   DOMAIN TO JOIN: $DOMAINTOJOIN" -ForegroundColor $ConfirmColour
        Write-Host -Object "*   Oupath: $OuPath" -ForegroundColor $ConfirmColour
        Write-Host -Object "*   IP: $IP" -ForegroundColor $ConfirmColour
        Write-Host -Object "*   DNS: $DNS" -ForegroundColor $ConfirmColour
        Write-Host -Object "*   CIDR: $CIDR" -ForegroundColor $ConfirmColour
        Write-Host -Object "*   Network Card: $NetworkCard" -ForegroundColor $ConfirmColour
        Write-Host -Object "*************************************************************************" -ForegroundColor $SuccessColour
        Write-Host -Object "*   Press any key to confirm or ctrl+c to cancel                        *" -ForegroundColor $SuccessColour
        Write-Host -Object "*************************************************************************" -ForegroundColor $SuccessColour
        Read-Host 
        #IP
        
        #VM Name
        try {
            if ($VMName -like '*DC*') {
                Write-Host -Object 'Is This a Domain Controller?' -ForegroundColor "$TxtColour" -NoNewline;
                Write-Host -Object 'Y/N' -ForegroundColor "$TxtColour" -NoNewline;
                $Answer = Read-Host;
            }
            if (($Answer -eq 'y') -or ($Answer -eq 'Y')) {
                <#
                Rename-Computer -NewName "$VMName"
                New-NetIPAddress –InterfaceAlias $NetworkCard.InterfaceAlias –IPv4Address $IP –PrefixLength 24 -DefaultGateway $DefaultGateway
                Set-DnsClientServerAddress –InterfaceAlias $NetworkCard.InterfaceAlias -ServerAddresses "$DNS"
                Remove-Item -LiteralPath 'c:\Init-VM' -Recurse -Force -Confirm
                #>
                Write-Host "Please manually add this pc to the domain."
            }
            else {
                <#
                New-NetIPAddress –InterfaceAlias $NetworkCard.InterfaceAlias –IPv4Address $IP –PrefixLength 24 -DefaultGateway $DefaultGateway
                Set-DnsClientServerAddress –InterfaceAlias $NetworkCard.InterfaceAlias -ServerAddresses "$DNS"
                Rename-Computer -NewName "$VMName"
                Add-Computer -DomainName "$DomainToJoin" -OUPath "$OuPath"
                Remove-Item -LiteralPath 'c:\Init-VM' -Recurse -Force -Confirm
                #>
            } 
        }  
        catch {
            Throw("ERROR in TC part")
        }     

    }
    
    end {
        Write-Host -Object "*************************************************************************" -ForegroundColor $SuccessColour
        Write-Host -Object "*   VMNAME: $VMName" -ForegroundColor $SuccessColour
        Write-Host -Object "*   DOMAIN TO JOIN: $DOMAINTOJOIN" -ForegroundColor $SuccessColour
        Write-Host -Object "*   Oupath: $OuPath" -ForegroundColor $SuccessColour
        Write-Host -Object "*   IP: $IP" -ForegroundColor $SuccessColour
        Write-Host -Object "*   DNS: $DNS" -ForegroundColor $SuccessColour
        Write-Host -Object "*   CIDR: $CIDR" -ForegroundColor $SuccessColour
        Write-Host -Object "*   Network Card: $NetworkCard" -ForegroundColor $SuccessColour
        Write-Host -Object "*************************************************************************" -ForegroundColor $SuccessColour
        Write-Host -Object "*   Press any key to restart                                            *" -ForegroundColor $SuccessColour
        Write-Host -Object "*************************************************************************" -ForegroundColor $SuccessColour
        Read-Host
        Restart-Computer -Force
    
    }
}
#Global variable
$global:TxtColour = 'Cyan';
$global:ConfirmColour = 'yellow';
$global:SuccessColour = 'Green';

Init-DiffVM