$Form1 = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Button]$btn = $null
[System.Windows.Forms.Label]$lblMAC = $null
[System.Windows.Forms.TextBox]$txtMAC = $null
function InitializeComponent {
    $btn = (New-Object -TypeName System.Windows.Forms.Button)
    $lblMAC = (New-Object -TypeName System.Windows.Forms.Label)
    $txtMAC = (New-Object -TypeName System.Windows.Forms.TextBox)
    $form1.SuspendLayout()
    #
    # lblMAC
    #
    $lblMAC.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12, [System.Int32]10))
    $lblMAC.Name = [System.String]'lblMAC'
    $lblMAC.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100, [System.Int32]23))
    $lblMAC.TabIndex = 1
    $lblMAC.Text = 'MAC'
    $lblMAC.UseCompatibleTextRendering = $true
    #
    # txtMAC
    #
    $txtMAC.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]120, [System.Int32]10))
    $txtMAC.Name = [System.String]'txtMAC'
    $txtMAC.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]200, [System.Int32]23))
    $txtMAC.TabIndex = 2
    #
    # btn
    #
    $btn.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]220, [System.Int32]100))
    $btn.Name = [System.String]'btn'
    $btn.Padding = (New-Object -TypeName System.Windows.Forms.Padding -ArgumentList @([System.Int32]3))
    $btn.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100, [System.Int32]23))
    $btn.TabIndex = 5
    $btn.Text = 'Submit'
    $btn.UseVisualStyleBackColor = $true
    $btn.add_Click($btn_Click)
    $Form1.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]380, [System.Int32]170))
    $Form1.Controls.Add($lblMAC)
    $Form1.Controls.Add($txtMAC)
    $Form1.Controls.Add($chkWhatIf)
    $Form1.Controls.Add($chkConfirm)
    $Form1.Controls.Add($btn)
    $Form1.Text = [System.String]'Form1'
    $Form1.ResumeLayout($true)
    Add-Member -InputObject $Form1 -Name btn -Value $btn -MemberType NoteProperty
    Add-Member -InputObject $Form1 -Name lblMAC -Value $lblMAC -MemberType NoteProperty
    Add-Member -InputObject $Form1 -Name txtMAC -Value $txtMAC -MemberType NoteProperty
    Add-Member -InputObject $Form1 -Name chkWhatIf -Value $chkWhatIf -MemberType NoteProperty
    Add-Member -InputObject $Form1 -Name chkConfirm -Value $chkConfirm -MemberType NoteProperty
}
. InitializeComponent
