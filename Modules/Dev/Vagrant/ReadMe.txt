Vagrant fokussed on hyper-v creation.
Used to create a POC setup showing the way we could set up a fast test lab.

Vision: 
creation of a test lab. 
Machines should be created based on somekind of variable
$LabName = 'TestLab'
$DomainName = 'Lab.local'
1 * $LabName-DC01
1 * $LabName-MDS01

1* ParrotOS Machine
    Installation of tools
    installation of enhanced session mode based on
        https://www.kali.org/docs/virtualization/install-hyper-v-guest-enhanced-session-mode/
        https://www.discoveringdata.org/index.php/2020/09/11/enable-enhanced-session-mode-on-parrot-os-guest-within-hyper-v/
        Configuration method:
        sudo git clone https://github.com/mimura1133/linux-vm-tools /opt/linux-vm-tools
        sudo chmod 0755 /opt/linux-vm-tools/kali/2020.x/install.sh
        echo 'echo "exec mate-session" > ~/.xinitrc exec mate-session' > /opt/linux-vm-tools/kali/2020.x/install.sh
        sudo /opt/linux-vm-tools/kali/2020.x/install.sh
        sudo reboot -f

        From Host:
        Set-VM "ParrotOSMachineName" -EnhancedSessionTransportType HVSocket