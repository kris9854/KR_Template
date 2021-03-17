<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Form_staticIP
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form_FindStaticIp = New-Object system.Windows.Forms.Form
$Form_FindStaticIp.ClientSize = New-Object System.Drawing.Point(451, 387)
$Form_FindStaticIp.text = "Find Static Ip"
$Form_FindStaticIp.TopMost = $false
$Form_FindStaticIp.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#e4e0e0")

$btn_findstaticip = New-Object system.Windows.Forms.Button
$btn_findstaticip.text = "Find static ip"
$btn_findstaticip.width = 114
$btn_findstaticip.height = 44
$btn_findstaticip.location = New-Object System.Drawing.Point(321, 18)
$btn_findstaticip.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)

$txtb_subnet = New-Object system.Windows.Forms.TextBox
$txtb_subnet.multiline = $false
$txtb_subnet.width = 153
$txtb_subnet.height = 20
$txtb_subnet.location = New-Object System.Drawing.Point(153, 18)
$txtb_subnet.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)

$lbl_subnet = New-Object system.Windows.Forms.Label
$lbl_subnet.text = "Subnet or ip in subnet:"
$lbl_subnet.AutoSize = $true
$lbl_subnet.width = 25
$lbl_subnet.height = 10
$lbl_subnet.location = New-Object System.Drawing.Point(9, 21)
$lbl_subnet.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)

$lbl_Neededips = New-Object system.Windows.Forms.Label
$lbl_Neededips.text = "Number of needed ip`'s:"
$lbl_Neededips.AutoSize = $true
$lbl_Neededips.width = 25
$lbl_Neededips.height = 10
$lbl_Neededips.location = New-Object System.Drawing.Point(9, 43)
$lbl_Neededips.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)

$txtb_numberofneededaddress = New-Object system.Windows.Forms.TextBox
$txtb_numberofneededaddress.multiline = $false
$txtb_numberofneededaddress.text = "1"
$txtb_numberofneededaddress.width = 153
$txtb_numberofneededaddress.height = 20
$txtb_numberofneededaddress.location = New-Object System.Drawing.Point(153, 42)
$txtb_numberofneededaddress.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)

$lbl_CreatedBy = New-Object system.Windows.Forms.Label
$lbl_CreatedBy.text = "Created by Kristian script only works for /24"
$lbl_CreatedBy.AutoSize = $true
$lbl_CreatedBy.width = 25
$lbl_CreatedBy.height = 10
$lbl_CreatedBy.location = New-Object System.Drawing.Point(293, 378)
$lbl_CreatedBy.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 6)

$btn_back = New-Object system.Windows.Forms.Button
$btn_back.text = "Close/Back"
$btn_back.width = 74
$btn_back.height = 25
$btn_back.location = New-Object System.Drawing.Point(14, 353)
$btn_back.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)

$ListBox_PopulatedValue = New-Object system.Windows.Forms.ListBox
$ListBox_PopulatedValue.text = "listBox"
$ListBox_PopulatedValue.width = 426
$ListBox_PopulatedValue.height = 219
$ListBox_PopulatedValue.location = New-Object System.Drawing.Point(12, 117)

$lbl_ListBox = New-Object system.Windows.Forms.Label
$lbl_ListBox.text = "List of availible Ip`'s:"
$lbl_ListBox.AutoSize = $true
$lbl_ListBox.width = 25
$lbl_ListBox.height = 10
$lbl_ListBox.location = New-Object System.Drawing.Point(13, 97)
$lbl_ListBox.Font = New-Object System.Drawing.Font('Microsoft Sans Serif', 10)

$Prgbar_Listavail = New-Object system.Windows.Forms.ProgressBar
$Prgbar_Listavail.text = "Gathering Information"
$Prgbar_Listavail.width = 152
$Prgbar_Listavail.height = 18
$Prgbar_Listavail.location = New-Object System.Drawing.Point(152, 70)

$Form_FindStaticIp.controls.AddRange(@($btn_findstaticip, $txtb_subnet, $lbl_subnet, $lbl_Neededips, $txtb_numberofneededaddress, $lbl_CreatedBy, $btn_back, $ListBox_PopulatedValue, $lbl_ListBox, $Prgbar_Listavail))

$btn_findstaticip.Add_Click( { Get-StaticIp -Subnet $txtb_subnet.text -NeededIPs $txtb_numberofneededaddress.text -ListBoxName $ListBox_PopulatedValue })
$btn_back.Add_MouseClick( { $Form_FindStaticIp.close })



## Dont delete under this
[void]$Form_FindStaticIp.ShowDialog()