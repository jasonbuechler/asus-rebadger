
$predownload = @"

** Oh, because I couldn't think of a(n easy) better way, this script will delete your ~/.ssh/* if you proceed
** This won't matter to 99.99% of people, including people who don't know what this is. 
                    ^^^^^^^^^ read this ^^^^^^^^^^

** In a moment, you will TWICE be prompted to type a password.
** This password is "password".

"@


write-host $predownload
pause
rm  ~/.ssh/*

# get router IP from current IP
$ipv4 = (Get-NetIPAddress -InterfaceIndex $ii).ipv4address
$ipv4 = "$ipv4".trim()
$gw = $ipv4 -replace "\.\d+$",".1"

# may need diff options for most recent fw?
$opts = "-oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false"

# SSH & SCP strings
# don't forget semicolons and (probably) end-quotes
$cmds = @"
"
cat /dev/mtd0 > original_cfe.bin; 
ls -al
"
"@
$cmds = $cmds -replace "\n",""


# ssh -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false admin@192.168.29.1 "cat /dev/mtd0 > original_cfe.bin; ls -al"
# scp -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false admin@192.168.29.1:~/original_cfe.bin ./original_cfe.bin
cmd /c "ssh $opts admin@$gw $cmds"
cmd /c "scp $opts admin@$gw`:~/original_cfe.bin ./original_cfe.bin"

$postdownload = @"

** You should now scroll up slightly to verify that The Badger (successfully) copied
** and downloaded your current "CFE" bootloader. (It used these commands...)
**    > ssh $opts admin@$gw $cmds
**    > scp $opts admin@$gw`:~/original_cfe.bin ./original_cfe.bin

"@
write-host $postdownload