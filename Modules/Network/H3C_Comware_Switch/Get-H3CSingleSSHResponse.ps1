function Get-H3CSingleSSHResponse {
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]$HostAddress,
        [Parameter(Mandatory = $false)]
        [Int]$HostPort = 22,
        [Parameter(Mandatory = $true)]
        [PSCredential]$Credential = $Global:credObject,
        [Parameter(Mandatory = $false)]
        [Switch]$AcceptKey,
        [Parameter(Mandatory = $true)]
        [String]$Command,
        [Parameter(Mandatory = $false)]
        [String]$StripHeaderAt = $null
    )
    $SSHSession = $null
    $SSHSession = New-SSHSession -ComputerName $HostAddress -Port $HostPort -Credential $Credential -AcceptKey:$AcceptKey;
        
    if ($SSHSession.Connected -eq $true) {
        $SSHResponse = Invoke-SSHCommand -SSHSession $SSHSession -Command $Command;
    
        $SSHSessionRemoveResult = Remove-SSHSession -SSHSession $SSHSession;

        if (-Not $SSHSessionRemoveResult) {
            Write-Host "Could not remove SSH Session $($SSHSession.SessionId):$($SSHSession.Host).";
        }

        $Result = $SSHResponse.Output | Out-String;

        $StartIndex = 0;

        if ($StripHeaderAt) {
            $StartIndex = $Result.IndexOf("`n$StripHeaderAt") + 1;
        }
        $ReturnValue = $Result.Substring($StartIndex).Replace("`r`n", "`n").Trim();
        return($ReturnValue)
    }
    else {
        throw [System.InvalidOperationException]"Could not connect to SSH host: $($HostAddress):$HostPort.";
    }   
    $SSHSessionRemoveResult = Remove-SSHSession -SSHSession $SSHSession;

    if (-Not $SSHSessionRemoveResult) {
        Write-Host "Could not remove SSH Session $($SSHSession.SessionId):$($SSHSession.Host).";
    }
}