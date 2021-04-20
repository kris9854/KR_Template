function Create-ServerEnv {
    [CmdletBinding()]
    param (
        # Path
        [Parameter(Mandatory = $false)]
        [string]
        $Path = $env:HOMEDRIVE
    )
    
    begin {
        if (-not [bool](Get-Item -Path 'C:\Server' -ErrorAction SilentlyContinue)) {
            $Path = New-Item -Path $Path -Name 'Server'
            New-Item -Path $Path -Name 'Disk'
            New-Item -Path $Path -Name 'VM'
        }  
    }
    
    process {
        
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
        $EnvFileLocation = '.\HypervEnv.ps1'
    )
    
    begin {
        if (-not $VMName) {
            Write-Host -Object 'Please provice a name for the new machine, IF you want to create multiple press ANY button: "' -ForegroundColor "$Global:ForegroundColour" -NoNewline
            $VMName = Read-Host -ErrorAction SilentlyContinue
            if (($VMName -eq $CSV) -or ([string]::IsNullOrEmpty($vmName))) {   
            } 
        }
    }
    
    process {
        
    }
    
    end {
        
    }
}