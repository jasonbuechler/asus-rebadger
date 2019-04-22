#https://www.bleepingcomputer.com/news/microsoft/heres-how-to-enable-the-built-in-windows-10-openssh-client/
#https://man.openbsd.org/ssh
#scp scp://USERNAME@HOST:PORT//FILEPATH/file.txt ./
#ssh ssh://USERNAME@HOST:PORT

echo Badger is on the move

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if($currentPrincipal -ne 'True'){ 
	write-host 'you done bad. relaunch this as an admin'
    Exit
}

write-host 'Enabling the TFTP "windows feature"'
Enable-WindowsOptionalFeature -Online -FeatureName "TFTP" -all

$tftpstate = (Get-WindowsOptionalFeature -FeatureName "TFTP" -online).State
if($tftpstate -ne 'Enabled'){
    write-host 'Couldnt enable TFTP feature'
    Exit
}

$cnt = 0
while($cnt -lt 4){
    $ping = test-connection -ComputerName google.com -Quiet -Count 1
    if ($ping){ $cnt++ }
    else{ $cnt = 0 }
    write-host $cnt' pings in-a-row, so far'
}
write-host 'hey wadda you know its been up: 4 in a row'
