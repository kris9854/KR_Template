function Reset-Switch {
    [CmdletBinding()]
    param (
        # COMPORT
        [Parameter(Mandatory = $false)]
        [string]
        $COMPORT = 'COM5',

        # DeviceName Uses Network device types
        [Parameter(Mandatory = $false)]
        [Validateset(
            'Cisco.IOS',
            'Comware7',
            'Cisco.IOSX',
            'Cisco.Nexus'
        )]
        [string]
        $ModelType = 'Comware7',

        # Path to Text Fil for HP device
        [Parameter(Mandatory = $false)]
        [string]
        $Comware7_Reset = "$PSScriptRoot\Switch_Reset_Commands\Comware7_Reset.txt",

        # Path to Text Fil for Cisco device
        [Parameter(Mandatory = $false)]
        [string]
        $Cisco_IOS_Reset = "$PSScriptRoot\Switch_Reset_Commands\Cisco_IOS_Reset.txt"
    )
    
    begin {
        # Create the commands based on the device type
        switch ($ModelType) {
            Cisco.IOS {
                [bool]$ModelTypeSet = $true
                [array]$ResetCommands = (Get-Content -Path "$Cisco_IOS_Reset") 
                Break;
            }
            Comware7 {
                [bool]$ModelTypeSet = $true

                [array]$ResetCommands = (Get-Content -Path "$Comware7_Reset") 
                Break;
            }
            Default {
                [bool]$ModelTypeSet = $false
                Write-Verbose -Message 'Please provide a Network Device'
            }
        }
        if (!$ModelTypeSet) {
            return("Please provide a Network Device")
        }


        $Port_Con = New-Object System.IO.Ports.SerialPort "$COMPORT", 9600, None, 8, one
    }
    
    process {
        [array]$PortLineRead
        $Port_Con.open()
        #$Port_Con.ReadLine() # Deletes 
        foreach ($Line in $ResetCommands) {
            Write-Verbose -Message "Processing: $Line"

            Start-Sleep -Seconds 3
            $Port_Con.WriteLine("$Line")
            Start-Sleep -Seconds 3
        }
        $PortLineRead = $Port_Con.ReadLine()
        Write-Debug -Message "$PortLineRead"
    }
    
    end {
        $Port_Con.Close()
        Return("$PortLineRead")
    }
}