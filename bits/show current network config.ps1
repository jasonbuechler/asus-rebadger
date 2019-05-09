# previously selecting your network adapter is mandatory
if(-not $ii){
    write-host "You need to select your network adapter before you can do this."
    write-host "  (use menu option A)"
    pause
    Exit
}

write-host "** The Badger notes your current configuration is:"
$eths | format-table
write-host "** Your network adapter is #$ii"
write-host "** Your network adapters name is" $eths.name
write-host "** Your current configuration looks like:"
netsh int ip show addresses $eths.name
write-host ''
