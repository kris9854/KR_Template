<#
Script for getting information about the Operating system. 

#>
function Get-Info {
    <#
    .SYNOPSIS

    .DESCRIPTION
    Get OS information
    
    .PARAMETER HostName
    The hostname of the PC 
    
    .EXAMPLE
    Get-Info -HostName 'Computer1'
    Get-info -HostName '10.0.0.20'
    .NOTES
    Retrives Information about the host 
    #>
    [CmdletBinding()]
    param (
        # The Ip or HostName of the machine
        [Parameter(Mandatory = $true)]
        [string]
        $HostName
    )
    
    begin {
        $Online = Test-Connection -ComputerName N101692 -Count 1 -Quiet
            
    }

}
    
process {
    try {
        if ($Online) {
            $env:PROCESSOR_IDENTIFIER 


        }   
    }
    catch {
            
    }
       
}
    
end {
    finally {
            
    }
}
}