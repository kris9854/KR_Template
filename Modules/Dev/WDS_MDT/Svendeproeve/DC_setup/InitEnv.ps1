# For initializing the DC env
$location = (Get-Location).Path
$oulist = Import-Csv -Path "$location\oulist.txt"
ForEach ($entry in $oulist) {
    $ouname = $entry.ouname
    $oupath = $entry.oupath
    New-ADOrganizationalUnit -Name $ouname -Path $oupath
    Write-Host -ForegroundColor Green "OU $ouname is created in the location $oupath"
}