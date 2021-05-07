Set-Location "$PSScriptRoot"
$host.ui.RawUI.WindowTitle = 'KR_Template'
$Host.UI.RawUI.BackgroundColor = 'Black'
$Host.UI.RawUI.ForegroundColor = 'Gray'
$Host.PrivateData.FormatAccentColor = Green
$Host.PrivateData.ErrorAccentColor = Cyan
$Host.PrivateData.ErrorForegroundColor = Red
$Host.PrivateData.ErrorBackgroundColor = Black
$Host.PrivateData.WarningForegroundColor = Yellow
$Host.PrivateData.WarningBackgroundColor = Black
$Host.PrivateData.DebugForegroundColor = Yellow
$Host.PrivateData.DebugBackgroundColor = Black
$Host.PrivateData.VerboseForegroundColor = Yellow
$Host.PrivateData.VerboseBackgroundColor = Black
$Host.PrivateData.ProgressForegroundColor = Black
$Host.PrivateData.ProgressBackgroundColor = Yellow
Clear-Host
pwsh.exe -NoExit -command ". .\MainScript.ps1"