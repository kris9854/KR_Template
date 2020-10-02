<#
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

#>
#using module "$PSScriptRoot\anothermodule.psm1"
#Region DLL's and System Objects
Add-Type -AssemblyName System.Windows.Forms     #Can be created with windows form tools like saphiere or postgree
#Add-Type -AssemblyName PresentationFramework    #https://trumpexcel.com/vba-msgbox/
Clear-Host                          #Clears the powershell windows messages
#Endregion DLL's and System Objects
#Region Script Specific variables.
[string]$ScriptName = 'ScriptTemplate'      #Name of your script
$VersionTemplate = '3.0.0'          #Template Script Version
$VersionScript = '1.0.0'            #Script Version
[string]$ScriptAuthor = 'Kristian Ebdrup'   #Script Author
#Endregion Script Specific variables.

#Region variables and Global Values
$global:ScriptPath = Split-Path $script:MyInvocation.MyCommand.Path
[datetime]$Date = Get-Date -Format "dd-MM-yy-HHmm"
[datetime]$startDTM = (Get-Date) # Get Start Time
#Endregion variables and Global Values

#Region Import "TemplateFunction.psm1" and "TemplateClasses.ps1"
Import-Module "$ScriptPath\TemplateFunction.psm1" -Verbose
. .\TemplateClasses.ps1 #Imports the Classes specified in the file 
#Endregion Import "TemplateFunction.psm1"

#Region Call function
$ErrorActionPreference = "SilentlyContinue"
New-Directory -DirName 'Log'
New-Directory -DirName 'Forms'
#New-Directory -DirName 'Output'
#New-Directory -DirName 'Files'
$ErrorActionPreference = "Continue"
#Endregion call function
#############################################################################################################################
#Region Script Execution Start
#Region Main
#_#_#_#_#_#_#_#_#_#_#_#_#_#_#_#

#Endregion Main

#Region Script ending
Write-Log -Message "Elapsed Time: $(((Get-Date)-$startDTM).TotalSeconds) seconds" -Level 'INFO'
#Endregion Script ending
#Endregion Script Execution Start

#Forms establishment
#main (not yet created)
#Form Find_static_ip
. $Forms\Form_staticip.ps1