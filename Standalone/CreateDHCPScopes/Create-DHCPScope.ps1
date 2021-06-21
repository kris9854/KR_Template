function Create-CSVFile {
    [CmdletBinding()]
    param (
        # Default CSVFileLocation
        [Parameter(Mandatory = $false)]
        [string]
        $CSVFileLocation = "$PSScriptRoot\Automated_DHCP_CSV\Auto_DHCPScopes.csv"
    )
    
    begin {
        #Locale run location .\ = "$PSScriptRoot"
        $FGC = 'yellow'
        Set-Location "$PSScriptRoot" #Sets the location to where the script is initiated from
        #$CsvImport = Import-Csv -Delimiter ';' -Path $CSVFileLocation -Encoding default
        $CsvImport = Get-Content -Path $CSVFileLocation -Raw

        #Region Ask User for input
        Write-Host -Object "Please Provide a location (example BJE or GMA): " -ForegroundColor "$FGC"
        $Location = Read-Host

        Write-Host -Object "Please Provide a Client_Network_ID (example 10.0.20.0): " -ForegroundColor "$FGC"
        $Client_Network_ID = Read-Host

        Write-Host -Object "Please Provide a Voice_Network_ID (example 10.0.21.0): " -ForegroundColor "$FGC"
        $Voice_Network_ID = Read-Host

        #Endregion Ask User for Input


        $lookupTable = @{
            '{{Location}}'          = "$Location"
            '{{Client_Network_ID}}' = "$Client_Network_ID"
            '{{Voice_Network_ID}}'  = "$Voice_Network_ID"
        }
    }
    
    process {
        $Global:NewCsvFile = $CsvImport | ForEach-Object {
            $line = $_
            $lookupTable.GetEnumerator() | ForEach-Object {
                if ($line -match $_.Key) {
                    $line = $line -replace $_.name, $_.Value
                }
            }
            $line
        } 
    }
    
    end {
        Write-Debug -Message "$lookupTable"
        Write-Debug -Message "$NewCsvFile"
        $OutFilePath = "$PSScriptRoot" + "\Automated_DHCP_CSV\Auto_Gen_DHCPScopes.csv"
        Write-Debug -Message $OutFilePath
        Out-File -InputObject "$NewCsvFile" -FilePath "$OutFilePath" -Force
        #Export-Csv -Path "$OutFilePath" -Encoding UTF8 -Delimiter ';' -NoTypeInformation -InputObject "$NewCsvFile"
    }
}

function Create-DHCPScopes {
    <#
    .SYNOPSIS
    Used to create DHCP scopes based on a csv file
    
    .DESCRIPTION
        Used to create DHCP scopes based on a csv file
    
    .PARAMETER dhcpserver
    Parameter description
    The DHCP server ip or name defaults to local pc
    
    .PARAMETER CsvImportPath
    Parameter description
    The path to with the csv file is located defaults to DHCPScopes.csv in same folder.
    csv headers: 
    Scopename;NetworkID
    
    .EXAMPLE
     Create-LKKORPDHCPScope 
     <- Creates a DHCP scope based on values from a CSV file ->
    
    .NOTES
     <- CSV Explaination ->
     <- SCOPENAME -> The name of the scope given to the scope
     <- NETWORKID -> The Network ID exs: 10.0.100.0 - subnet will be set througnh script
    #>
    [CmdletBinding()]
    param (
        # DHCP Server
        [Parameter(Mandatory = $false, HelpMessage = "Please enter the DHCP Server Name")]
        [string]
        $dhcpserver = "10.0.240.220",

        # Csv Import location
        [Parameter(Mandatory = $false, HelpMessage = "Please enter the CSV from where data should be read")]
        [string]
        $CsvImportPath = "$PSScriptRoot\Automated_DHCP_CSV\Auto_Gen_DHCPScopes.csv",

        # Csv Import location
        [Parameter(Mandatory = $false, HelpMessage = "Please enter the lease time for the scopes (default: 1 day)")]
        [string]
        $Lease = '1.00:00:00',

        # Csv Import location
        [Parameter(Mandatory = $false, HelpMessage = "Please enter the Subnet mask (default: 255.255.255.0)")]
        [string]
        $subnetmask = '255.255.255.0'
    )
    
    begin {
        Set-Location "$PSScriptRoot" #Sets the location to where the script is initiated from
        $CsvImport = Import-Csv -Delimiter ';' -Path $CsvImportPath -Encoding default
    }
    
    process {
        
        foreach ($CSVFile in $CsvImport) {
            # Make $null Init Variables 
            [string]$scopename = $null       #name of the scope
            [string]$ScopeID = $null           #Scope Ip
            # SPlitting Part
            $FirstOctet = $null
            $SecondOctet = $null
            $ThirdOctet = $null
            [string]$ScopeIDSSplit = $null
            # Automating the scopes to follow network standards 
            
            [string]$startrange = $null
            [string]$endrange = $null
            [string]$router = $null



            #Define Variables based on the imported CSV
            [string]$scopename = $CSVFile.Scopename       #name of the scope
            [string]$ScopeID = $CSVFile.NetworkID           #Scope Ip
            Write-Host -Object "Creating DHCP Network ID $ScopeID with the name $ScopeName" -ForegroundColor Yellow
            # SPlitting Part
            $FirstOctet = $ScopeID.split('.')[0]
            $SecondOctet = $ScopeID.split('.')[1]
            $ThirdOctet = $ScopeID.split('.')[2]
            [string]$ScopeIDSSplit = "$FirstOctet" + '.' + "$SecondOctet" + '.' + "$ThirdOctet" + '.'
            # Automating the scopes to follow network standards 
            [string]$startrange = $ScopeIDSSplit + '51'
            [string]$endrange = $ScopeIDSSplit + '254'
            [string]$router = $ScopeIDSSplit + '1'
        
            # Creating scope
            Add-DHCPServerv4Scope -EndRange $endrange -Name $scopename -StartRange $startrange -SubnetMask $subnetmask -State Active -LeaseDuration $Lease
            # Adding router
            Set-DHCPServerv4OptionValue -ScopeId $scopeID -Router $router
        }
    }
    
    end {
        #TEST
        sleep 10
    }
}
Write-Host "Function: Create-GFDHCPScope; Create-CSVFile" -ForegroundColor Yellow
#Create-CSVFile
#Create-GFDHCPScope