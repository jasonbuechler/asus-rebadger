# previously selecting your network adapter is now mandatory
if(-not $ii){
    write-host "You need to select your network adapter before you can do this."
    write-host "  (use menu option A)"
    pause
    Exit
}

# get router IP from current IP
$ipv4 = (Get-NetIPAddress -InterfaceIndex $ii).ipv4address
$ipv4 = "$ipv4".trim()
$gw = $ipv4 -replace "\.\d+$",".1"

write-host "Immediately executing TFTP transfer to $gw ..."

tftp -i $gw put TM-AC1900_3.0.0.4_376_1703-g0ffdbba.trx

$posttftp = @"
               ^^^^^^                                                      <
           THIS IS THE TFTP RESULT!                                        <
-----------------------------------------------------                      <
                                                                           <
** The TFTP step is over.                                                  <
** If all went well, the router should be rebooting right now.             <
**                                                                         <
** You'll know it's fully rebooted when both 2.4 & 5ghz wifi LEDs are on.  <

"@
write-host -backgroundcolor red $posttftp


# if current subnet == \1 ......
$posttftp2 = @"

** you should see something like xfer successful
** REMINDER: since presumably you're flashing this via subnet 1
** because you're reverting FROM asus firmware, the subnet 1
** LAN configuration is still set in NVRAM... so even though
** it's now got Tmo firmware, its webgui is on subnet 1...
** AND the admin configuration is also still set: admin/admin.

** But...
** ...if you saw "Connect request failed" as an error following
** the TFTP push, and your router is on a very very recent 
** version of tmo's firmware (v3199+) you may need to do a 
** bunch of extra steps. Visit here for more info:
** https://github.com/jasonbuechler/asus-rebadger/wiki/Troubleshooting

"@
#write-host $posttftp2


pause