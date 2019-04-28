write-host "Oh, because I couldn't think of a(n easy) better way, this script will delete your ~/.ssh/* if you proceed"
write-host "This won't matter to 99.99% of people, including people who don't know what this is. Proceed?"
pause

rm  ~/.ssh/*

write-host '** Now copying 3 files to the router via SCP...'
write-host '**   (new_cfe.bin, mtd-write, FW_RT_AC68U_30043763626.trx)'
scp -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false new_cfe.bin mtd-write FW_RT_AC68U_30043763626.trx admin@192.168.29.1:~/

write-host '** ...SCP copy complete.'
write-host ''
write-host '** Now listing files, installing bootloader, and installing FW_RT_AC68U_30043763626.trx...'
write-host '**   (chmod 777 mtd-write -->  '
write-host '**      ls -al --> '
write-host '**         ./mtd-write -i new_cfe.bin -d boot -->  '
write-host '**             mtd-write2 FW_RT_AC68U_30043763626.trx linux)  '
write-host ''
ssh -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false admin@192.168.29.1 "chmod 777 mtd-write; ls -al; ./mtd-write -i new_cfe.bin -d boot; mtd-write2 FW_RT_AC68U_30043763626.trx linux"

write-host '** (Should be a CRC verification after mtd-write2)'