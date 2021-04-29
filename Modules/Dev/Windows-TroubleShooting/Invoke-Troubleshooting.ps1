function Invoke-Troubleshooting {
    [CmdletBinding()]
    param (
        # Problem
        [Parameter(Mandatory = $false)]
        [string]
        $Problem
    )
    
    begin {
        $TSCatalogPath = 'C:\Windows\diagnostics\system\'
        $TSCatalog = (Get-ChildItem -Path 'C:\Windows\diagnostics\system\').FullName
        $GuiColour = 'yellow'
        [int]$Count = '1'
    }
    
    process {
        Write-Host ***************************************** -ForegroundColor $GuiColour
        foreach ($TSPackage in $TSCatalog) {
            Write-Host $Count -ForegroundColor $GuiColour -NoNewline
            $Package = $TSPackage.split('\')[-1]
            Write-Host -Object ": $Package" -ForegroundColor $GuiColour
            $Count++
        }
        Write-Host ***************************************** -ForegroundColor $GuiColour
        Write-Host '' -ForegroundColor $GuiColour
        Write-Host -Object 'Please Input the name of the diagnostic you want to run: ' -ForegroundColor 'green' -NoNewline
        $ReadInput = Read-Host
        switch ($ReadInput) {
            'Networking' { Write-Host -Object '! PRESS Enter when prompted for instance ID !' -ForegroundColor 'green' }
            Default {
                Write-Host -Object 'Please Interact with the CLI if input is needed' -ForegroundColor 'green'
            }
        }
        
        Write-Host ''
        $ChoosenTSPackage = "$TSCatalogPath\$ReadInput"
        $Diag = Get-TroubleshootingPack $ChoosenTSPackage | Invoke-TroubleshootingPack
        
    }
    
    end {
        Return($Diag)
    }

}