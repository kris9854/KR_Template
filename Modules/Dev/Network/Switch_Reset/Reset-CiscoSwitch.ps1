if (!$user) { $user = Read-Host -Prompt 'User Creds' }
if (!$UserPassword) { $UserPassword = Read-Host -Prompt 'Insert Password' }

$Comport = [System.IO.Ports.SerialPort]::getportnames()[-1]
Write-Host "$Comport" -ForegroundColor Green
$port = New-Object System.IO.Ports.SerialPort $Comport, 9600, None, 8, one
$port.open()
Start-Sleep -Seconds 1
$port.WriteLine(“$user”)
Start-Sleep -Seconds 1
$port.WriteLine(“$UserPassword”)
Start-Sleep -Seconds 1
$port.WriteLine('Enable')
Start-Sleep -Seconds 1
$port.WriteLine('write erase')
Start-Sleep -Seconds 1
$port.WriteLine('y')
Start-Sleep -Seconds 1
$port.ReadLine()
Start-Sleep -Seconds 1
$port.Close()