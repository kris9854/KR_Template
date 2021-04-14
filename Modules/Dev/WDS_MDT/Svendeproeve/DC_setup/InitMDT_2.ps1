#Init the MDT Server
Write-Host "Have you installed Windows ADK? If Not exit this"
Read-Host
Install-WindowsFeature -Name WDS -IncludeManagementTools
WDSUTIL /Verbose /Progress /Initialize-Server /Server:MDT01 /RemInst:"D:\RemoteInstall"
WDSUTIL /Set-Server /AnswerClients:All

New-Item -Path D:\Logs -ItemType directory
New-SmbShare -Name Logs$ -Path D:\Logs -ChangeAccess EVERYONE
icacls D:\Logs /grant '"SA-MDT_BA":(OI)(CI)(M)'