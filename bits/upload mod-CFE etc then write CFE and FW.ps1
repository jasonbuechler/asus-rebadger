$preupload = @"

** Oh, because I couldn't think of a(n easy) better way, this script will delete your ~/.ssh/* if you proceed
** This won't matter to 99.99% of people, including people who don't know what this is. 
                    ^^^^^^^^^ read this ^^^^^^^^^^

** In a moment, you will TWICE be prompted to type a password.
** This password is "password".

"@

write-host $preupload
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
chmod 777 mtd-write; 
ls -al; 
./mtd-write -i new_cfe.bin -d boot; 
mtd-write2 FW_RT_AC68U_30043763626.trx linux
"
"@
$cmds = $cmds -replace "\n",""
$push_files = "new_cfe.bin mtd-write FW_RT_AC68U_30043763626.trx"



write-host ''
write-host '** Now copying/uploading 3 files to the router via SCP...'
write-host '**   (new_cfe.bin, mtd-write, FW_RT_AC68U_30043763626.trx)'
write-host '** Via this command: '
write-host '**    > scp $opts $push_files admin@$gw`:~/ '
write-host ''



# scp -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false new_cfe.bin mtd-write FW_RT_AC68U_30043763626.trx admin@192.168.29.1:~/
# holy shit this is cleaner
cmd /c "scp $opts $push_files admin@$gw`:~/"

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
** Via this command:
**    > ssh $opts admin@$gw $cmds

"@
write-host $postSCPpreSSH



# ssh -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false admin@192.168.29.1 "chmod 777 mtd-write; ls -al; ./mtd-write -i new_cfe.bin -d boot; mtd-write2 FW_RT_AC68U_30043763626.trx linux"
# i mean come on look how much more readable!
cmd /c "ssh $opts admin@$gw $cmds"

$postSSH = @"

** ...SSH executation phase comp.. comp.. com... compl... complete.          <
** Above, you should just see the remote directory listing AND right under   <
** it, "linux: CRC OK" if the trx flashed successfully.                      <
**                                                                           <
** You should also scroll up slightly to verify the upload went OK.          <

"@
write-host -backgroundcolor red $postSSH