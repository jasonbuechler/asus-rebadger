write-host ''
write-host '****************************'
write-host '** The Badger is on the move'
write-host '****************************'
write-host ''




#
# get the "identity" of the user running powershell
# then check to see if this identity has admin privileges
# bail if not
#
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -ne 'True'){ 
	write-host '** You done bad. relaunch this as an admin'
    Break
}



#
# for any future debugging
# sorry 'bout the laziness
#
write-host '** This script is being from from: '$PSScriptRoot
write-host '** *.trx files in this directory:'
ls *trx
write-host '** Proceeding without checking if all the files are present (!!!)'
write-host ''
pause




#
# check to see if TFTP is already enabled
# if not, try to enable it, then check once again to be sure
# bail if no dice
#
write-host '** Checking if the TFTP "windows feature" is already enabled'
$tftpstate = (Get-WindowsOptionalFeature -FeatureName "TFTP" -online).State
if($tftpstate -ne 'Enabled'){
    write-host '** TFTP wasnt enabled'
    write-host '** Enabling the TFTP "windows feature" now'
    Enable-WindowsOptionalFeature -Online -FeatureName "TFTP" -all
    
    # check again to verify tftp is enabled
    $tftpstate = (Get-WindowsOptionalFeature -FeatureName "TFTP" -online).State
    if($tftpstate -ne 'Enabled'){
        write-host '** Couldnt enable TFTP feature'
        write-host '** If this didnt work, nothing else is going to'
        write-host '** You should kill/close this now.'
        pause
        Break
    }
}else{
    write-host '** TFTP is enabled. How cool!'
}





#
# figure out the ethernet adapter which might be 'Connected' but not 'Up' 
# (such as in the case of not receiving DHCP)
# $eths = get-netadapter -physical | where status -eq 'up'
#
write-host '** The Badger sees these network adapters:'
get-netadapter -physical | where status -ne 'Disconnected'
$eths = get-netadapter -physical | where status -ne 'Disconnected'
write-host ''
if( ($eths | measure).Count -ne 1 ){
    write-host '** You currently have '$eths.count' network adapters online. Connect exactly 1.'
    Break
}else{
    $ii = $eths.ifIndex
    write-host '** Your network adapter is #'$ii
    write-host '** Your network adapters name is'$eths.name
    write-host '** Your current configuration looks like:'
    netsh int ip show addresses $eths.name
}





#
# set manual IP in subnet 29
#
write-host '** The Badger is now attempting to set a manual IP: 192.168.29.xx...'
write-host '** (Your IP needs to be in subnet 29 to communicate with the T-Mo firmware, in recovery mode)'
write-host ''
If (($eths | Get-NetIPConfiguration).IPv4Address.IPAddress) {
    Remove-NetIPAddress -AddressFamily ipv4 -Confirm:$false -InterfaceIndex $ii
}
If (($eths | Get-NetIPConfiguration).Ipv4DefaultGateway) {
    Remove-NetRoute -AddressFamily ipv4 -Confirm:$false -InterfaceIndex $ii
}
New-NetIPAddress -InterfaceIndex $ii -IPAddress 192.168.29.5 -PrefixLength 24 -DefaultGateway 192.168.29.1 | Out-Null
#Set-DnsClientServerAddress -ServerAddresses 192.168.29.1 -InterfaceIndex $ii





#
# the configuration change has started but may take a few seconds
# do some waiting.
# show some info for any future debugging
#
while ( -not (Get-NetIPAddress -InterfaceIndex $ii).ipv4address ){
    write-host '** (Waiting for IPv4 address to set...)'
    Start-Sleep -Seconds 2
}
while ( (Get-NetIPAddress -InterfaceIndex $ii -AddressFamily ipv4).addressState -eq 'Tentative' ){
    write-host '** (Waiting for IPv4 address to finalize...)'
    Start-Sleep -Seconds 2
}
write-host '** ...done. (Unless you saw some ugly powershell error.)'
write-host '** Your current configuration looks like:'
netsh int ip show addresses $eths.name
pause





#
# the environment should be all ready now
# now we prompt the user to IRL reboot the router holding the button down continuously
# ...and try to push tftp image to it
#
$piar = 0
$threshold = 3
#while($cnt -lt 60){
for($i=0; $i -lt 40; $i++){
    if( test-connection -ComputerName 192.168.29.1 -Quiet -Count 1 ) { $piar++ }
    else{ $piar = 0 }
    write-host '** '$piar' pings in-a-row, so far'
    if($piar -gt $threshold){ 
        write-host '** Hey wadda you know its been up for '$piar' in a row...'
        write-host '** Its party time.'
        break 
    }
}
$i
if($i -eq 39){
    write-host '** Its been 40 seconds... the window has closed.'
    write-host '** Its been 40 seconds... the window has closed.'
    write-host '** Its been 40 seconds... the window has closed.'
    write-host '** Its been 40 seconds... the window has closed.'
}

tftp -i 192.168.29.1 put FW_RT_AC68U_30043763626.trx


#document.querySelector('#telnet_tr').style.display = ''
#document.querySelector('#telnet_tr').querySelectorAll('.input')[0].disabled = false
#document.querySelector('#telnet_tr').querySelectorAll('.input')[1].disabled = false





#
# set the adapter back to dhcp
# I don't know if we need to pay any attention to the latent netRoute but meh.
# It does minimize cruft on my screen while testing starting from iffy configs, so...
#
write-host '** The Badger is now attempting to use DHCP'
$interface = Get-NetIPInterface -AddressFamily IPv4 -ifindex $ii
If ($interface.Dhcp -eq "Disabled") {

    # Remove existing gateway
    If (($interface | Get-NetIPConfiguration).Ipv4DefaultGateway) {
        #$interface | Remove-NetRoute -Confirm:$false
        #Remove-NetRoute -NextHop 192.168.29.1
        Remove-NetRoute -InterfaceIndex $ii -Confirm:$false
    }

    # Enable DHCP
    $interface | Set-NetIPInterface -DHCP Enabled
    # Configure the DNS Servers automatically
    #$interface | Set-DnsClientServerAddress -ResetServerAddresses
}
#$c = 0
#while ( (Get-NetIPAddress -InterfaceIndex $ii).AddressState ){
#    write-host '** no state yet! ***********'
#    (Get-NetIPAddress -InterfaceIndex $ii -AddressFamily IPv4).AddressState
#    (Get-NetIPAddress -InterfaceIndex $ii).ipv4address
#    pause
#    if($c -gt 4){ break }else{$c++}
#}




#
# DHCP is apparently quite ... temperamental.
# Sometimes my lease is instantly restored, and sometimes it dies with a 169...
# We'll try to be patient and renew the lease if necessary
#
while ( -not (Get-NetIPAddress -InterfaceIndex $ii).ipv4address ){
    write-host '** (Waiting for IPv4 address to set...)'
    Start-Sleep -Seconds 2
}
write-host '** The Badger is taking a 10 second break to check his phone.'
write-host '** (Also, Windows is checking your DHCP lease.)'
Start-Sleep -Seconds 10
$ipv4 = (Get-NetIPAddress -InterfaceIndex $ii).IPv4Address
write-host '** Your network adapters ip address is now '$ipv4
if( $ipv4 -like '169*'){
    write-host '** Since you have a 169 address, the DHCP lease needs to be renewed.'
    write-host '** The Badger is doing his best...'
    ipconfig /renew $eths.name
    $ipv4 = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $ii).IPAddress
    write-host '** Your network adapters ip address is now '$ipv4
}
write-host ''
write-host '** Your current configuration looks like:'
netsh int ip show addresses $eths.name






#https://www.bleepingcomputer.com/news/microsoft/heres-how-to-enable-the-built-in-windows-10-openssh-client/
#https://man.openbsd.org/ssh
#scp scp://USERNAME@HOST:PORT//FILEPATH/file.txt ./
#ssh ssh://USERNAME@HOST:PORT

#https://devblogs.microsoft.com/scripting/using-powershell-to-find-connected-network-adapters/
# get-netadapter -physical | where status -eq 'up'
# (get-netadapter -physical | where status -eq 'up').ifIndex
# (get-netadapter -physical | where status -eq 'up').name
# Get-NetAdapter -physical | Where-Object { $_.Status -ne 'Disconnected' }
# Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex 7
# help Set-NetIPAddress -examples

#https://www.pdq.com/blog/using-powershell-to-set-static-and-dhcp-ip-addresses-part-1/
# Get-NetIPInterface -ifIndex 11 -AddressFamily IPv4
# Set-NetIPInterface -Dhcp Enabled
# New-NetIPAddress -InterfaceIndex 11 -IPAddress 10.10.10.10 -PrefixLength 24 -DefaultGateway 10.10.10.1


# https://stackoverflow.com/questions/13869182/how-to-get-the-default-gateway-from-powershell
# https://powershell.org/forums/topic/problem-with-showing-properties-of-netipconfiguration-object/
# http://techgenix.com/interacting-tcp-ip-through-powershell-part3/
