. 'd:\Kristian\Projects\KR_Template\Forms\MacAuto\macgui.ps1'
Add-Type -AssemblyName System.Windows.Forms
$btn_Click = {
	Get-MACVendor -MAC $txtMAC.Text
}
. 'd:\Kristian\Projects\KR_Template\Forms\MacAuto\macgui.form.designer.ps1'
$Form1.ShowDialog()
