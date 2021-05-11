function Create-Credentials {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]
        $userName
    )
    # Asking for credentials:
   
    if (-Not $userName) {
        Write-Host "Insert Username: " -ForegroundColor "$TextColour" -NoNewline
        [string]$userName = Read-Host
    }
    
    Write-Host "Type in password: " -ForegroundColor "$TextColour" -NoNewline
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
        $TxtColour = 'Cyan';
        $ConfirmColour = 'yellow';
        $SuccessColour = 'Green';

        #Domain Dependence
        $DomainToJoin = 'LKKORP.LOCAL';
        $OuPath = 'OU=VM,OU=Servers,OU=Computers,OU=LKCorp,DC=LKKORP,DC=local"'

        #Credential Creation for Domain Join
        $CredObject = Create-Credentials -userName "$($DomainToJoin.Split('.')[0])\SA-MDT"

        #VM NAME
        Write-Host -Object 'Please Insert the Name of this VM' -ForegroundColor "$TxtColour" -NoNewline;
        $VMName = Read-Host;
        $VmName = "$($DomainToJoin.Split('.')[0])-$VMName";
        
        #Ip address
        Write-Host -Object 'IP address?' -ForegroundColor "$TxtColour" -NoNewline;
        [System.Net.IPAddress]$IP = Read-Host;
        $DNS = 10.0.10.100 #Standard
        [System.Net.IPAddress]$DefaultGateway = "10.0.$($IP.ToString().split('.')[2]).1";
        $CIDR = '24'
        $NetworkCard = Get-NetAdapter | Where-Object { $_.Name -eq 'Ethernet' }

    }
    
    process {

        #IP
        New-NetIPAddress –InterfaceAlias $NetworkCard.InterfaceAlias –IPv4Address $IP –PrefixLength 24 -DefaultGateway $DefaultGateway
        Set-DnsClientServerAddress –InterfaceAlias $NetworkCard.InterfaceAlias -ServerAddresses "$DNS"
        #VM Name
        if ($VMName -like '*DC*') {
            Write-Host -Object 'Is This a Domain Controller?' -ForegroundColor "$TxtColour" -NoNewline;
            Write-Host -Object 'Y/N' -ForegroundColor "$TxtColour" -NoNewline;
            $VMName = Read-Host;
        }
        Rename-Computer -NewName "$VMName"
        Add-Computer -DomainName "$DomainToJoin" -OUPath "$OuPath"

    }
    
    end {
        Remove-Item -LiteralPath 'c:\Init-VM' -Recurse -Force -Confirm
    }
}
Init-DiffVM