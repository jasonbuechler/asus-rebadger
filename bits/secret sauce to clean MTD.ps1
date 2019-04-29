write-host "Oh, because I couldn't think of a(n easy) better way, this script will delete your ~/.ssh/* if you proceed"
write-host "This won't matter to 99.99% of people, including people who don't know what this is. Proceed?"
pause

rm  ~/.ssh/*

write-host '** You will once again be asked, just once this time, to enter a password.'
write-host '** The password is now "admin"'

$secretsauce = @"
** Unless you see an obvious error above, we successfully added the secret sauce!

   ....................................................
   cat /dev/mtd5 > /jffs/mtd5_backup.bin
   mkdir /tmp/asus_jffs
   mount -t jffs2 /dev/mtdblock5 /tmp/asus_jffs
   rm -rf /jffs/.sys/RT-AC68U /tmp/asus_jffs/*
   sync && umount /tmp/asus_jffs
   nvram unset fw_check && nvram commit && reboot
   ....................................................

** The router should be rebooting on its own.
** You can use (i) at the main menu to check when it's done.

** We should be all done, now!
** If anything went wrong, you'll have to do steps (g) thru (j) again. :(

"@


ssh -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false admin@192.168.1.1 "cat /dev/mtd5 > /jffs/mtd5_backup.bin; mkdir /tmp/asus_jffs; mount -t jffs2 /dev/mtdblock5 /tmp/asus_jffs; sync && umount /tmp/asus_jffs; rm -rf /jffs/.sys/RT-AC68U /tmp/asus_jffs/*; nvram unset fw_check && nvram commit && reboot"
    
write-host $secretsauce