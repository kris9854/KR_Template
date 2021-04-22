function Create-ServerEnv {
    [CmdletBinding()]
    param (
        # Path
        [Parameter(Mandatory = $false)]
        [string]
        $VMPath = $env:HOMEDRIVE
    )
    
    begin {
        # Variable Read
        $VirtualHardDiskPath = (Get-VMHost).VirtualHardDiskPath
        $VirtualMachinePath = (Get-VMHost).VirtualMachinePath

        if ((-not [bool](Get-Item -Path 'C:\Server' -ErrorAction SilentlyContinue)) -or
            (-not [bool](Get-Item -Path 'C:\Server\Disk' -ErrorAction SilentlyContinue)) -or
            (-not [bool](Get-Item -Path 'C:\Server\VM' -ErrorAction SilentlyContinue))) {
                
            New-Item -Path $Path -Name 'Server'
            $VMPath = $VMPath + '\server'
            New-Item -Path $VMPath -Name 'Disk'
            $VMDiskPath = $VMPath + '\Disk'
            New-Item -Path $VMPath -Name 'VM'
            $VMPath = $VMPath + '\VM'
        }  
    }
    
    process {
        # Set Default values for hyper-v 
        if (($VirtualHardDiskPath -ne $VMDiskPath) -or 
            ($VirtualMachinePath -ne $VMPath)) {

            Set-VMHost -VirtualHardDiskPath "$VMDiskPath" -VirtualMachinePath "$VMPath"
        }
    }
    
    end {
        
    }
}
function Create-DefinedVM {
    <#
    .SYNOPSIS
    
    .DESCRIPTION
    This function should provide the user with a easier way of creating VM's
    This is created for my upcoming "Svendeproeve" so the envfile as been preconfigured for that. 
    
    .PARAMETER VMName
    Parameter description
    
    .PARAMETER ParameterName
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        # The Name of the new  $VM
        [Parameter(Mandatory = $false)]
        [string]
        $VMName,
        # EnvFileLocation
        [Parameter(Mandatory = $false)]
        [string]
        $EnvFileLocation = '.\HypervEnv.ps1',
        # Csvheader Containing the hostnames
        [Parameter(Mandatory = $false)]
        [string]
        $CSVHeader = 'ServerName'
    )
    
    begin {
        Create-ServerEnv
        # Variable location
        $CliCoulour = 'Yellow'
        # Variable Read count
        [string]$VMParentDisk = [string]$Global:StandardVMParentDisk
        [int]$VMGen = [int]$Global:StandardVMGen
        [int]$ServerVlan = [int]$Global:StandarServerVlan
        [int]$ClientVlan = [int]$Global:StandardClientVlan

        # Output to PS CLI
        Write-Host -Object '##########################################' -ForegroundColor $CliCoulour
        Write-Host -Object "##      VM Parent Disk: $VMParentDisk   ##" -ForegroundColor $CliCoulour
        Write-Host -Object "##      VM Generation: $VMGen           ##" -ForegroundColor $CliCoulour
        Write-Host -Object "##      Server Vlan: $ServerVlan        ##" -ForegroundColor $CliCoulour
        Write-Host -Object "##      Client Vlan: $ClientVlan        ##" -ForegroundColor $CliCoulour
        Write-Host -Object '##########################################' -ForegroundColor $CliCoulour

        
        if (-not $VMName) {
            Write-Host -Object 'Please provice a name for the new machine, IF you want to create multiple press ANY button: "' -ForegroundColor "$Global:ForegroundColour" -NoNewline
            $VMName = Read-Host -ErrorAction SilentlyContinue
            if (($VMName -eq $CSV) -or ([string]::IsNullOrEmpty($vmName))) {
                $CsvImport = (Import-Csv -Path '.\servers.csv' -Encoding Default -Delimiter ';').$CSVHeader
            } 
        }
        else {
            # To reduce code later i will set the csvimport name equal to the VMNAME
            $CsvImport = $VMName
        }
    }
    
    process {
        # Device Creation process
        foreach ($VM in $CsvImport) {
            
            
        }
    }
    
    end {
        
    }
}