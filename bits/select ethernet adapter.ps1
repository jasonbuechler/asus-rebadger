write-host "** BEFORE PROCEEDING..."
write-host "**  make sure your computer is directly connected to"
write-host "**  a YELLOW ethernet port (specifically #1) on the router."
write-host "**  AKA: don't be connected to the BLUE wan port."
write-host ""
pause

write-host "** The Badger sees these network adapters:"
$eths = get-netadapter -physical | where status -in ("Up","Connected")
$eths | format-table
write-host ''


$ethscount = ($eths | measure).Count
if( $ethscount -ne 1 ){
    write-host "** You currently have $ethscount network adapters online. Disconnect/disable all but 1."
    write-host "** Actually you have one chance to enter the ifIndex number of your ethernet adapter..."
    $ii = Read-Host -Prompt "Ethernet ifIndex number"
    $eths = get-netadapter -InterfaceIndex $ii
    if($eths){
        write-host "** OK, we're going with" $eths.name
        break
    }else{
        write-host "** Yeah, no. That couldnt have been it. Bailing."
        pause
        Exit
    }
}else{
    $ii = $eths.ifIndex
	write-host ''
	write-host "** The badger has automatically selected your network adapter, for you." -foregroundcolor yellow
	write-host "**  (...Because it's currently the only eligible network adapter.)" -foregroundcolor yellow
	write-host "** Please verify this is correct." -foregroundcolor yellow
	write-host ''
}
