
This script consist of 2 funtinalities
First: ScriptTemplate
Secound "Insert Script name"

Functionalities of "Insert Script name"
    .
    .
Version 1.0.0

This Script has 1 "ScriptTemplate"
    .Holds Basic stript paths for every script designed by Kristian
    .Varible creation based on created path
    .Function created
Version Table For ScriptTemplate
    .Version 1.0.0 - First major release of ScriptTemplate
    .Version 1.0.1 - Basic Script front
    .Version 1.0.2 - Added try and catch
    .Version 1.0.3 - Added Test and folder creation
    .Version 1.0.4 - Added Variable Test in New-Directory function
    .Version 1.0.5 - Advanced Function to New-Directory Function, Also added the PresentationFramework DLL
    .Version 1.0.6 - Added better log feature.
        .Logging feature called Write-Log -Message * -Level Warn, Info or Error
    .Version 1.0.7 - Added out-null to new-directory to remove standard output from command execution
    .Version 1.0.8 - Added "Script Specific variables"
    .Version 1.0.9 - Created New varoables
    .Version 1.1.0 - added time execution Check
    .Version 2.0.0 - new template major version
    .Version 3.0.0 -
        .New template major version
        .Created a Powershell Module to hold the functions

Shortcut help: https://code.visualstudio.com/shortcuts/keyboard-shortcuts-windows.pdf

New Powershell Module has been created "TemplateFunction.psm1"
.Version 1.0.0
    - New-Directory
        .Creates a New-Directory in the scriptpath of the script
    - Write-Log
        .Creates a Log file located under "Log" directory
    - Show-Msgbox
        .Can create a Message Box
        .Example of Show-Msgbox
#####################################Example####################################################################################
        $question_result = Show-Msgbox -message "Is Excel open?" -icon "exclamation" -button "YesNo" -title "Are you sure?"
        $ExcelProc = Get-Process -Name "*Excel*"
        if($ExcelProc -EQ $true){
            Switch ($question_result) {
                "Yes" { $ExcelProc | Stop-Process }
                "No" { Exit }
        }
        }
#####################################Example#END################################################################################
    -