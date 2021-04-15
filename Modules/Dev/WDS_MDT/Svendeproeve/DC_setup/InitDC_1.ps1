# https://docs.microsoft.com/en-us/windows/deployment/deploy-windows-mdt/create-a-windows-10-reference-image
# For initializing the DC env
$location = (Get-Location).Path
$oulist = Import-Csv -Path "$location\oulist.txt"
ForEach ($entry in $oulist) {
    $ouname = $entry.ouname
    $oupath = $entry.oupath
    New-ADOrganizationalUnit -Name $ouname -Path $oupath
    Write-Host -ForegroundColor Green "OU $ouname is created in the location $oupath"
}


#Init The MDT User
New-ADUser -Name MDT_BA -UserPrincipalName 'SA-MDT_BA' -Path "OU=Service Accounts,OU=Accounts,OU=LKCorp,DC=LAB,DC=LOCAL" -Description "Service ACCount for MDT Build Account" -AccountPassword (ConvertTo-SecureString "Asdf1234" -AsPlainText -Force) -ChangePasswordAtLogon $false -PasswordNeverExpires $true -Enabled $true