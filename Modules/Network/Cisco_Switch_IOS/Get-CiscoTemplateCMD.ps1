function Get-CiscoTemplateCMD {
    # Can be used to send multiple commands to a switch.
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]$HostAddress,

        [Parameter(Mandatory = $false)]
        [Int]$HostPort = 22,

        [Parameter(Mandatory = $false)]
        [PSCredential]$Credential = $credObject,

        [Parameter( HelpMessage = 'save an "$objectForScript = Get-Content -path INSERT LOCATION OF file -Raw"',
            Mandatory = $true,
            Validate)]
        [array]$CMDTemplate,

        # SleepTimerin milisecound
        [Parameter(Mandatory = $false)]
        [bigint]
        $SleepTimerMiliSec = '60'
    )
    
    begin {
        $sshsession = $null
        $SSHShellStream = $null
        [int]$Counter = 1
        $TotalCMDCount = $CMDTemplate.count
        [array]$SSHRespondArray = @()
    }
    
    process {
        $sshsession = New-SSHSession -ComputerName "$HostAddress" -Credential $Credential -AcceptKey -ErrorAction silentlyContinue;
        if ($SSHSession.Connected) {
            #Creates a shell stream for us to feed commands to:
            $SSHShellStream = New-SSHShellStream -Session $sshsession;
            if ($SSHShellStream.Session.IsConnected) {
                
                foreach ($LineCMD in $CMDTemplate) {
                    [void]$SSHShellStream.Read()
                    $SSHShellStream.WriteLine("$LineCMD")
                    Write-Host "$Counter Of $TotalCMDCount CMD's run" -ForegroundColor $Global:TextColour
                    Write-Debug "cmd: $LineCMD" 
                    [array]$SSHRespondArray += $SSHShellStream.Read()
                    if ($LineCMD -contains 'acl') {
                        Start-Sleep -Milliseconds "120"
                    }
                    Start-Sleep -Milliseconds "$SleepTimerMiliSec"
                    $counter++
                }
                
            }             
            
            $SSHSessionRemoveResult = Remove-SSHSession -SSHSession $SSHSession;
            if (-Not $SSHSessionRemoveResult) {
                Write-Host -ForegroundColor "$Global:TextColour" -Object "Could not remove SSH Session $($SSHSession.SessionId):$($SSHSession.Host).";
            }   
        }
        else {
            Write-Host -ForegroundColor "$Global:TextColour" -Object "Could not connect to SSH host: $($HostAddress):$HostPort.";
        }
    
    }
    
    end {
        $SSHRespondArray = $SSHResponse.Output | Out-String;
        $StartIndex = 0;
        Return $SSHRespondArray.Substring($StartIndex).Replace("`r`n", "`n").Trim();
    }
}