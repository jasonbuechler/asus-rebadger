rm  ~/.ssh/*

$secretsauce = @"
....................................................
cat /dev/mtd5 > /jffs/mtd5_backup.bin
mkdir /tmp/asus_jffs
mount -t jffs2 /dev/mtdblock5 /tmp/asus_jffs
rm -rf /jffs/.sys/RT-AC68U /tmp/asus_jffs/*
sync && umount /tmp/asus_jffs
# rm -rf /jffs/.sys/RT-AC68U #combined with prev rm
nvram unset fw_check && nvram commit && reboot
....................................................
"@

write-host $secretsauce


ssh -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false admin@192.168.1.1 "cat /dev/mtd5 > /jffs/mtd5_backup.bin; mkdir /tmp/asus_jffs; mount -t jffs2 /dev/mtdblock5 /tmp/asus_jffs; sync && umount /tmp/asus_jffs; rm -rf /jffs/.sys/RT-AC68U /tmp/asus_jffs/*; nvram unset fw_check && nvram commit && reboot"
    