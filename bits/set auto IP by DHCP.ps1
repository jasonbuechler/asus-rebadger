if(-not $ii){
    write-host "You need to select your network adapter before you can do this."
    write-host "  (use menu option A)"
    pause
    Exit
}


#
# apparently (?) it's a best practice (or necesssary?) to remove
# previous "net routes" before re-enabling DHCP. *shrug*
#
write-host '** The Badger is now attempting to get an IP automatically through DHCP...'
$interface = Get-NetIPInterface -AddressFamily IPv4 -ifindex $ii
If ($interface.Dhcp -eq "Disabled") {

    # Remove existing gateway
    If (($interface | Get-NetIPConfiguration).Ipv4DefaultGateway) {
        #$interface | Remove-NetRoute -Confirm:$false
        #Remove-NetRoute -NextHop 192.168.29.1
        Remove-NetRoute -InterfaceIndex $ii -Confirm:$false
        write-host ''
        write-host '** If there is a "NetRoute" error above... 99% chance you can just ignore it.'
        write-host ''
    }

    # Enable DHCP
    $interface | Set-NetIPInterface -DHCP Enabled

    # Configure the DNS Servers automatically
    #$interface | Set-DnsClientServerAddress -ResetServerAddresses
}

#
# this part is not quite the same thing as "waiting for router to come back up"
#   (re: the other modules by similar names)
# this part mostly exists to make sure DHCP gets renewed
#
while ( -not (Get-NetIPAddress -InterfaceIndex $ii).ipv4address ){
    write-host '** (Waiting for IPv4 address to set...)'
    Start-Sleep -Seconds 2
}
write-host '** The Badger is taking a 10 second break to check his phone.'
write-host '** (Also, Windows is checking your DHCP lease.)'
Start-Sleep -Seconds 10
$ipv4 = (Get-NetIPAddress -InterfaceIndex $ii).IPv4Address
write-host "** Your network adapters ip address is now $ipv4 "
if( $ipv4 -like '169*'){
    write-host ''
    write-host '** Since you have a 169 address, the DHCP lease needs to be renewed.'
    write-host '** The Badger is doing his best...'
    write-host '** (Executing ipconfig /renew...)'
    write-host ''
    ipconfig /renew $eths.name | out-null
    $ipv4 = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $ii).IPAddress
    write-host '** Your network adapters ip address is now '$ipv4
}
write-host ''
write-host '** Your current configuration looks like:'
netsh int ip show addresses $eths.name