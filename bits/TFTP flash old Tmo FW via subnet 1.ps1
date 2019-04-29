write-host "Immediately executing TFTP transfer via subnet 1..."

tftp -i 192.168.1.1 put TM-AC1900_3.0.0.4_376_1703-g0ffdbba.trx

$posttftp = @"

** you should see something like xfer successful
** REMINDER: since presumably you're flashing this via subnet 1
** because you're reverting FROM asus firmware, the subnet 1
** LAN configuration is still set in NVRAM... so even though
** it's now got Tmo firmware, its webgui is on subnet 1...
** AND the admin configuration is also still set: admin/admin.

"@

write-host $posttftp
pause