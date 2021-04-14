#Init the MDT Server
New-Item -Path D:\Logs -ItemType directory
New-SmbShare -Name Logs$ -Path D:\Logs -ChangeAccess EVERYONE
icacls D:\Logs /grant '"SA-MDT_BA":(OI)(CI)(M)'