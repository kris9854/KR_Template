<#
This is a example on how to replace {{REPLACE}} in text files
The example uses is created in regards to switch configuration. But please be aware that anything can be replced with the values in the lookuptable array.
The following files has been tested to be able to do this
.txt
.csv (even csv with ; delimiter, base dilemeter for excel csv exports)
#>

function Create-ByTemplate {
    [CmdletBinding()]
    param (
        # Default CSVFileLocation
        [Parameter(Mandatory = $false)]
        [string]
        $Template = "$Template\TemplateExample\Example.conf"
          
    )
    
    begin {
        #Locale run location .\ = "$PSScriptRoot"
        $FGC = 'yellow'
        Set-Location "$PSScriptRoot" #Sets the location to where the script is initiated from
        #$CsvImport = Import-Csv -Delimiter ';' -Path $CSVFileLocation -Encoding default
        $TemplateImport = Get-Content -Path $Template -Raw

        #Region Ask User for input
        Write-Host -Object "Provide SwitchName" -ForegroundColor "$FGC"
        $SwitchName = Read-Host

        Write-Host -Object "Provide MNG_IP" -ForegroundColor "$FGC"
        $MNG_IP = Read-Host

        Write-Host -Object "Provide Admin_Password" -ForegroundColor "$FGC"
        $User_Password = Read-Host

        #Endregion Ask User for Input


        $lookupTable = @{
            '{{SwitchName}}'    = "$SwitchName"
            '{{MNG_IP}}'        = "$MNG_IP"
            '{{User_Password}}' = "$Admin_Password"
        }

        #Check For the OS of the switch
        if ($switch -eq 'IOS') {
            $TemplateSaveLocation = "$Template\TemplateExample\startup.conf"
        }
        else {
            $TemplateSaveLocation = "$Template\TemplateExample\startup.cfg"
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