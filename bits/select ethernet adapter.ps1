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
}


write-host "** Your network adapter is #$ii"
write-host "** Your network adapters name is" $eths.name
write-host "** Your current configuration looks like:"
netsh int ip show addresses $eths.name