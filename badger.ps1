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
    write-host '** Your network adapter is #'$eths.ifIndex
    write-host '** Your network adapters name is'$eths.name
}

#
# use the adapter's index to get its ipv4 address
#
$ipv4 = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $eths.ifIndex).IPAddress
write-host '** Your network adapters ip address is '$ipv4
write-host ''

#
# set manual IP in subnet 29
# this will fail if not already DHCP!!!
#
write-host '** The Badger is now attempting to set a manual IP address'
write-host '** (Your IP needs to be in subnet 29 to communicate with router in recovery mode)'
If (($eths | Get-NetIPConfiguration).IPv4Address.IPAddress) {
 $eths | Remove-NetIPAddress -AddressFamily ipv4 -Confirm:$false
}
If (($eths | Get-NetIPConfiguration).Ipv4DefaultGateway) {
 $eths | Remove-NetRoute -AddressFamily ipv4 -Confirm:$false
}
$newip = New-NetIPAddress -InterfaceIndex $eths.ifIndex -IPAddress 192.168.29.5 -PrefixLength 24 -DefaultGateway 192.168.29.1
$ipv4 = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $eths.ifIndex).IPAddress
$eths | Set-DnsClientServerAddress -ServerAddresses 192.168.29.1
write-host '** Your network adapters ip address is now '$ipv4
pause
write-host ''


#
# set the adapter back to dhcp
#
write-host '** The Badger is now attempting to use DHCP'
$interface = Get-NetIPInterface -AddressFamily IPv4 -ifindex $eths.ifIndex
pause
If ($interface.Dhcp -eq "Disabled") {
    ($interface | Get-NetIPConfiguration).Ipv4DefaultGateway
    pause

    # Remove existing gateway
    If (($interface | Get-NetIPConfiguration).Ipv4DefaultGateway) {
        #$interface | Remove-NetRoute -Confirm:$false
        #Remove-NetRoute -NextHop 192.168.29.1
        Remove-NetRoute -InterfaceIndex $eths.ifIndex
    }
    # Enable DHCP
    $interface | Set-NetIPInterface -DHCP Enabled
    # Configure the DNS Servers automatically
    $interface | Set-DnsClientServerAddress -ResetServerAddresses
    ipconfig /renew
}
Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $eths.ifIndex
pause
$ipv4 = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $eths.ifIndex).IPAddress
write-host '** Your network adapters ip address is now '$ipv4
write-host ''

$cnt = 0
$row = 3
while($cnt -lt $row){
    $ping = test-connection -ComputerName google.com -Quiet -Count 1
    if ($ping){ $cnt++ }
    else{ $cnt = 0 }
    write-host $cnt' pings in-a-row, so far'
    Break #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
}
write-host 'hey wadda you know its been up: '$row' in a row'



# https://stackoverflow.com/questions/13869182/how-to-get-the-default-gateway-from-powershell
# https://powershell.org/forums/topic/problem-with-showing-properties-of-netipconfiguration-object/
# http://techgenix.com/interacting-tcp-ip-through-powershell-part3/
