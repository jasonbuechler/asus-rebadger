write-host ""
write-host "Oh, because I couldn't think of a(n easy) better way, this script will delete your ~/.ssh/* if you proceed"
write-host "This won't matter to 99.99% of people, including people who don't know what this is. Proceed?"
pause

rm  ~/.ssh/*

write-host ''
write-host '** Now copying/uploading 3 files to the router via SCP...'
write-host '**   (new_cfe.bin, mtd-write, FW_RT_AC68U_30043763626.trx)'
write-host ''

scp -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false new_cfe.bin mtd-write FW_RT_AC68U_30043763626.trx admin@192.168.29.1:~/

$postSCPpreSSH = @"

** ...SCP copy/upload phase complete.
** Above, you should see the three files listed all at 100% (& some other stats).
**
** Now the badger will list the remote files, and "write" the modified bootloader & FW_RT_AC68U_30043763626.trx...
**    If you're curious, it's SSH'ing in and executing these:
**    > chmod 777 mtd-write 
**    > ls -al
**    > ./mtd-write -i new_cfe.bin -d boot 
**    > mtd-write2 FW_RT_AC68U_30043763626.trx linux

"@
write-host $postSCPpreSSH

ssh -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false admin@192.168.29.1 "chmod 777 mtd-write; ls -al; ./mtd-write -i new_cfe.bin -d boot; mtd-write2 FW_RT_AC68U_30043763626.trx linux"

$postSSH = @"

** ...SSH executation phase comp.. comp.. com... compl... complete.
** Above, you should just see the remote directory listing AND right under
** it, "linux: CRC OK" if the trx flashed successfully.

"@
write-host $postSSH