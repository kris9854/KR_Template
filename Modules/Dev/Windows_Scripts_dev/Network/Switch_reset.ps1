function Reset-Switch {
    [CmdletBinding()]
    param (
        # User
        [Parameter(Mandatory = $true)]
        [string]
        $User,

        # User
        [Parameter(Mandatory = $true)]
        [string]
        $UserPassword,

        # COMPORT
        [Parameter(Mandatory = $false)]
        [string]
        $COMPORT,

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
        $Cisco_IOS_Reset = "$PSScriptRoot\Switch_Reset_Commands\Cisco_IOS_Reset.txt",


    )
    
    begin {
        $lookupTable = @{
            '{{Password}}' = "$UserPassword"
            '{{User}}'     = "$User"
        }

        # Create the commands based on the device type
        switch ($ModelType) {
            Cisco.IOS {
                [bool]$ModelTypeSet = $true
                [array]$ResetCommands = (Get-Content -Path "$Cisco_IOS_Reset") | ForEach-Object {
                    $line = $_
                    $lookupTable.GetEnumerator() | ForEach-Object {
                        if ($line -match $_.Key) {
                            $line = $line -replace $_.name, $_.Value
                        }
                    }
                    $line
                }  
                Break;
            }
            Comware7 {
                [bool]$ModelTypeSet = $true

                [array]$ResetCommands = (Get-Content -Path "$Comware7_Reset") | ForEach-Object {
                    $line = $_
                    $lookupTable.GetEnumerator() | ForEach-Object {
                        if ($line -match $_.Key) {
                            $line = $line -replace $_.name, $_.Value
                        }
                    }
                    $line
                } 
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

        if (!$COMPORT) {
            $COMPORT = [System.IO.Ports.SerialPort]::getportnames()[1]
        }

        $Port = New-Object System.IO.Ports.SerialPort "$COMPORT", 9600, None, 8, one
    }
    
    process {
        [array]$PortLineRead
        $port.ReadTimeout = 9000
        $Port.open()
        foreach ($Line in $ResetCommands) {
            Write-Verbose -Message "Processing: $Line"

            Start-Sleep -Seconds 3
            $Port.WriteLine("$Line")
            Start-Sleep -Seconds 3
        }
        $PortLineRead = $Port.ReadExisting()
        Write-Debug -Message "$PortLineRead"
    }
    
    end {
        $Port.Close()
        Return("$PortLineRead")
    }
}