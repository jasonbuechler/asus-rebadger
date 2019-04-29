if(-not $ii){
    write-host "You need to select your network adapter before you can do this."
    write-host "  (use menu option A)"
    pause
    Exit
}

# "log" the current configuration for any future debugging
. '.\bits\show current network config.ps1'
write-host '** The Badger is now attempting to set a manual IP: 192.168.29.xx...'

# clean out old records
If (($eths | Get-NetIPConfiguration).IPv4Address.IPAddress) {
    Remove-NetIPAddress -AddressFamily ipv4 -Confirm:$false -InterfaceIndex $ii
}
If (($eths | Get-NetIPConfiguration).Ipv4DefaultGateway) {
    Remove-NetRoute -AddressFamily ipv4 -Confirm:$false -InterfaceIndex $ii
    write-host ''
    write-host '**   99% chance you can ignore the above error, if there is one'
    write-host '**   99% chance you can ignore the above error, if there is one'
    write-host ''
}

New-NetIPAddress -InterfaceIndex $ii -IPAddress 192.168.29.5 -PrefixLength 24 -DefaultGateway 192.168.29.1 | Out-Null
#Set-DnsClientServerAddress -ServerAddresses 192.168.29.1 -InterfaceIndex $ii
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