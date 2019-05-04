# get router IP from current IP
$ipv4 = (Get-NetIPAddress -InterfaceIndex $ii).ipv4address
$ipv4 = "$ipv4".trim()
$gw = $ipv4 -replace "\.\d+$",".1"

write-host "Immediately executing TFTP transfer to $gw ..."

tftp -i $gw put TM-AC1900_3.0.0.4_376_1703-g0ffdbba.trx

$posttftp = @"

                    ^^^^^^                                                 <
                THIS IS THE TFTP RESULT!                                   <
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

"@
write-host $posttftp2


pause