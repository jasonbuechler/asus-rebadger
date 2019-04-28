write-host "Oh, because I couldn't think of a(n easy) better way, this script will delete your ~/.ssh/* if you proceed"
write-host "This won't matter to 99.99% of people, including people who don't know what this is. Proceed?"
pause
 
rm  ~/.ssh/*
ssh -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false admin@192.168.29.1 "cat /dev/mtd0 > original_cfe.bin; ls -al"
scp -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false admin@192.168.29.1:~/original_cfe.bin ./original_cfe.bin