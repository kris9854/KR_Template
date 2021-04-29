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
            Write-Host $Count -ForegroundColor $GuiColour
            Write-Host -Object " : $TSPackage.split('\')[-1]"-NoNewline -ForegroundColor $GuiColour
            $Count++
        }
        Write-Host ***************************************** -ForegroundColor $GuiColour
        Write-Host '' -ForegroundColor $GuiColour
        Write-Host -Object 'Please Input the name of the diagnostic you want to run: ' -ForegroundColor 'green' -NoNewline
        $ReadInput = Read-Host
        $ChoosenTSPackage = "$TSCatalogPath\$ReadInput"
        $Diag = Get-TroubleshootingPack $ChoosenTSPackage
        
    }
    
    end {
        Write-Host $Diag.RootCause
        Return($DIAG)
    }

}