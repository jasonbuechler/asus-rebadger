##########################################################
##
## IF YOU OPENED THIS SCRIPT IN "PowerShell ISE"...
##    (as opposed to 'executing' it)
##       ...HIT THE GREEN 'PLAY/TRIANGLE', ABOVE.
##
##########################################################
cd $PSScriptRoot
$pwd = pwd
write-host ''
write-host '****************************'
write-host '** The Badger is on the move'
write-host '****************************'
write-host 'pwd is '$pwd


#
# verify we are an admin, and
# verify we are NOT using ISE (since that blocks interactive ssh)
#
$reopen = $false;
if ($host.name -match 'ISE') {
    $reopen = $true;
}
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -ne 'True'){ 
	$reopen = $true;
}
if($reopen){
    write-host '** This script needs to run with admin privileges, and outside of the ISE.'
    write-host '** The Badger will relaunch this script after you hit Enter, below.'
    write-host '** When you do so, you will be prompted by Windows User-Account-Control'
    write-host '** to grant admin rights & then this script will relaunch in another window.'
    write-host ''
    write-host '                   ^^^ READ THIS ^^^'
    write-host ''
    pause
    # Relaunch as an elevated process:
    Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
    exit
}




#
# for any future debugging
# sorry 'bout the laziness
#
write-host '** This script is being run from: '$PSScriptRoot
write-host '** These *.trx files are in this directory:'
ls *trx
write-host ''
write-host '** Proceeding without checking if all the files are present (!!!)'
write-host ''
pause





#
# check to see if TFTP is already enabled
# if not, try to enable it, then check once again to be sure
# bail if no dice
#
write-host '** Checking if the TFTP "windows feature" is already enabled'
$tftpstate = (Get-WindowsOptionalFeature -FeatureName "TFTP" -online).State
if($tftpstate -ne 'Enabled'){
    write-host '** TFTP wasnt enabled'
    write-host '** Enabling the TFTP "windows feature" now'
    Enable-WindowsOptionalFeature -Online -FeatureName "TFTP" -all
    
    # check again to verify tftp is enabled
    $tftpstate = (Get-WindowsOptionalFeature -FeatureName "TFTP" -online).State
    if($tftpstate -ne 'Enabled'){
        write-host '** Couldnt enable TFTP feature'
        write-host '** If this didnt work, nothing else is going to'
        write-host '** You should kill/close this now.'
        pause
        Break
    }
}else{
    write-host '** TFTP is enabled. How cool!'
}



#
# figure out the ethernet adapter which might be 'Connected' but not 'Up' 
# (such as in the case of not receiving DHCP)
# $eths = get-netadapter -physical | where status -eq 'up'
#
write-host '** The Badger sees these network adapters:'
$eths = get-netadapter -physical | where status -eq 'up'
$eths | format-table # !!!!! f#$@ing piece of s@#$*
write-host ''
if( ($eths | measure).Count -ne 1 ){
    write-host '** You currently have '$eths.count' network adapters online. Connect exactly 1.'
    pause
    Break
}else{
    $ii = $eths.ifIndex
    write-host '** Your network adapter is #'$ii
    write-host '** Your network adapters name is'$eths.name
    write-host '** Your current configuration looks like:'
    netsh int ip show addresses $eths.name
}





#
# set manual IP in subnet 29
#
write-host '** The Badger is now attempting to set a manual IP: 192.168.29.xx...'
write-host '**   (Your IP needs to be in subnet 29 to communicate with the T-Mo firmware, in recovery mode)'
write-host ''
If (($eths | Get-NetIPConfiguration).IPv4Address.IPAddress) {
    Remove-NetIPAddress -AddressFamily ipv4 -Confirm:$false -InterfaceIndex $ii
}
If (($eths | Get-NetIPConfiguration).Ipv4DefaultGateway) {
    Remove-NetRoute -AddressFamily ipv4 -Confirm:$false -InterfaceIndex $ii
}
New-NetIPAddress -InterfaceIndex $ii -IPAddress 192.168.29.5 -PrefixLength 24 -DefaultGateway 192.168.29.1 | Out-Null
#Set-DnsClientServerAddress -ServerAddresses 192.168.29.1 -InterfaceIndex $ii





#
# the configuration change has started but may take a few seconds
# do some waiting.
# show some info for any future debugging
#
while ( -not (Get-NetIPAddress -InterfaceIndex $ii).ipv4address ){
    write-host '** (Waiting for IPv4 address to set...)'
    Start-Sleep -Seconds 2
}
while ( (Get-NetIPAddress -InterfaceIndex $ii -AddressFamily ipv4).addressState -eq 'Tentative' ){
    write-host '** (Waiting for IPv4 address to finalize...)'
    Start-Sleep -Seconds 2
}
write-host '** ...done. (Unless you saw some ugly powershell error.)'
write-host '** Your current configuration looks like:'
netsh int ip show addresses $eths.name





#
# the environment should be all ready now
# now we prompt the user to IRL reboot the router holding the button down continuously
# ...and try to push tftp image to it
#
write-host '****************************************'
write-host '**                                      '
write-host '** YOUR INTERVENTION IS NOW REQUIRED'
write-host '**                                      '
write-host '** 1. turn the router off using the pushbutton (on the back)'
write-host '** 2. hold down the reset button (on the back)'
write-host '**      --> and dont release it until you see a message like this:'
write-host '**          "Transfer successful: 16949248 bytes in 62 second(s), 273374 bytes/s"'
write-host '** 3. turn the router on using the pushbutton'
write-host '** 4. NOW you can hit enter, here       '
write-host '**                                      '
write-host '****************************************'
pause
write-host ''
write-host ''
write-host '** Waiting for router to enter recovery mode...'
write-host '**   (If it takes > 40 sec, something went wrong)'


$piar = 0
$threshold = 3
$limit = 10 #!!!!!!!!!!!!!! should be 40-ish
for($i=0; $i -le $limit; $i++){  #!!!!!!!!!!!
    if( test-connection -ComputerName 192.168.29.1 -Quiet -Count 1 ) { $piar++ }
    else{ $piar = 0 }
    write-host '** ['$i'] '$piar' pings in-a-row, so far'
    if($piar -gt $threshold){ 
        write-host ''
        write-host ''
        write-host '** Hey wadda you know its been up for '$piar' in a row...'
        write-host '** Its party time.'
        write-host ''
        write-host ''
        break 
    }
}
if($i -ge $limit){
    write-host '** Its been 40 seconds... the tftp window has closed.'
    write-host '** Its been 40 seconds... the tftp window has closed.'
    write-host '** Its been 40 seconds... the tftp window has closed.'
    write-host '** Its been 40 seconds... the tftp window has closed.'
    write-host ''
    write-host '** You should proceed anyway, to set your network adapter back to DHCP'
    pause
}else{
    write-host '** Beginning TFTP transfer!!'
    write-host '** Remember: youll probably see nothing happening for 2 full agonizing minutes.'
    write-host '** Keep holding that reset button until you see the xfer is complete.'
    write-host ''

    tftp -i 192.168.29.1 put TM-AC1900_3.0.0.4_376_1703-g0ffdbba.trx
    write-host '                    ^^^^^^'
    write-host '                THIS IS THE TFTP RESULT!'
    write-host ''
    write-host '** The TFTP step is over, and the router is probably rebooting at this moment.'
    write-host '** The Badger now has more for you to do.'
    write-host '**   (If it failed, you should proceed anyway, to reset DHCP)'
    pause
}






write-host ''
write-host '** Waiting for the router to boot back up...'
write-host '**   (The Badger will wait longer this time, since there is no hurry.)'
$piar = 0
$threshold = 20
$limit = 60 
for($i=0; $i -le $limit; $i++){  
    if( test-connection -ComputerName 192.168.29.1 -Quiet -Count 1 ) { $piar++ }
    else{ $piar = 0 }
    write-host '** ['$i'] '$piar' pings in-a-row, so far'
    if($piar -gt $threshold){ 
        write-host ''
        write-host '** Oki dokey, its back up, now.'
        write-host ''
        break 
    }
}



write-host '****************************************'
write-host '**                                            '
write-host '** YOUR INTERVENTION IS AGAIN REQUIRED        '
write-host '**                                            '
write-host '** Now that the router has older firmware with more options, we must enable SSH:'
write-host '**                                            '
write-host '**   1. go to http://192.168.29.1/Advanced_System_Content.asp'
write-host '**   2. sign in as admin/password (the t-mo firmware default)'
write-host '**   3. click the "system" tab                '
write-host '**   4. enable SSH in the "SSH Daemon" section'
write-host '**   5. save/apply the configuration change   '
write-host '**   6. You now should be able to ssh to admin:password@192.168.29.1 '
write-host '**      ...and The Badger will attempt to do so, next.'
write-host '**   7. NOW you can hit enter, here           '
write-host '**                                            '
write-host '****************************************'
pause



write-host '**  YOU GON HAFTA TYPE password & HIT enter... TWO TIMES IN A ROW, SOON'
write-host '**  GOT IT?  THAT IS (2) TIMES IN A ROW! If youre ready, hit enter now.'

$opts = '-oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false'
ssh -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false admin@192.168.29.1 "cat /dev/mtd0 > original_cfe.bin; ls -al"
scp -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false admin@192.168.29.1:~/original_cfe.bin ./original_cfe.bin
#ssh $opts admin@192.168.29.1 "cat /dev/mtd0 > original_cfe.bin; ls -al"
#scp $opts admin@192.168.29.1:~/original_cfe.bin ./original_cfe.bin

################

write-host '** do your homework with the website > new_cfe.bin'

################

write-host '** Now copying 3 files to the router...'
scp -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false new_cfe.bin mtd-write FW_RT_AC68U_30043763626.trx admin@192.168.29.1:~/
write-host '** ...copy complete.'
write-host '** Now listing files, installing bootloader, and installing FW_RT_AC68U_30043763626.trx...'
ssh -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false admin@192.168.29.1 "chmod 777 mtd-write; ls -al; ./mtd-write -i new_cfe.bin -d boot && mtd-write2 FW_RT_AC68U_30043763626.trx linux"
write-host '** ...all that junk is complete. You do NOT need to reboot via webgui or SSH.'
write-host '** (Below, we will be using the routers physical buttons again.)'

####


$tricky = @"
** a. wait for reboot. reboot is complete...
**    --> when 192.168.1.1 responds to ping, and 
**    --> when both 2.4/5ghz wifi LEDs are on
** 
** NOW WE NVRAM RESET!!!
** b. Power off router
** c. Wait 10 seconds
** d. Press and hold WPS button
** e. Power up the router and continue to hold WPS button for 15-20 seconds until power LED starts blinking very quickly
** f. release the WPS button, and wait for the router to reboot again
** 
** Now we log in to the webgui, and enable ssh
** g. (verify you have already) Reset PC IP back to default
** h. Web-browser into router using ONLY using "http://192.168.1.1" (not an internal config page)
** i. For username/password, remember it is now: admin/admin
** j. skip the wizard, accept default all default settings, and enable SSH in system 
** 
** Now we SSH in and add the magic sauce
..............................................
cat /dev/mtd5 > /jffs/mtd5_backup.bin
mkdir /tmp/asus_jffs
mount -t jffs2 /dev/mtdblock5 /tmp/asus_jffs
rm -rf /tmp/asus_jffs/*
sync && umount /tmp/asus_jffs
rm -rf /jffs/.sys/RT-AC68U
nvram unset fw_check && nvram commit && reboot
...............................................

** Now we verify it's done (and if not, we try again)
** k. The top-left logo should now say "RT-ac68u" instead of "TM-AC1900"
** l. if it still says "TM-AC1900" start over at (a)
"@

write-host ''
write-host '** We are now going to loop'
write-host ''

for($i=0; $i -lt 5; $i++){ 
    $ip1 = $i+1
    write-host '** [ROUND '$ip1' OF 5]'
    write-host $tricky
    write-host ''
    pause
}


#
# set the adapter back to dhcp
# I don't know if we need to pay any attention to the latent netRoute but meh.
# It does minimize cruft on my screen while testing starting from iffy configs, so...
#
write-host '** The Badger is now ready to re-enable DHCP...'
pause
$interface = Get-NetIPInterface -AddressFamily IPv4 -ifindex $ii
If ($interface.Dhcp -eq "Disabled") {

    # Remove existing gateway
    If (($interface | Get-NetIPConfiguration).Ipv4DefaultGateway) {
        #$interface | Remove-NetRoute -Confirm:$false
        #Remove-NetRoute -NextHop 192.168.29.1
        Remove-NetRoute -InterfaceIndex $ii -Confirm:$false
    }

    # Enable DHCP
    $interface | Set-NetIPInterface -DHCP Enabled
    # Configure the DNS Servers automatically
    #$interface | Set-DnsClientServerAddress -ResetServerAddresses
}
#$c = 0
#while ( (Get-NetIPAddress -InterfaceIndex $ii).AddressState ){
#    write-host '** no state yet! ***********'
#    (Get-NetIPAddress -InterfaceIndex $ii -AddressFamily IPv4).AddressState
#    (Get-NetIPAddress -InterfaceIndex $ii).ipv4address
#    pause
#    if($c -gt 4){ break }else{$c++}
#}




#
# DHCP is apparently quite ... temperamental.
# Sometimes my lease is instantly restored, and sometimes it dies with a 169...
# We'll try to be patient and renew the lease if necessary
#
while ( -not (Get-NetIPAddress -InterfaceIndex $ii).ipv4address ){
    write-host '** (Waiting for IPv4 address to set...)'
    Start-Sleep -Seconds 2
}
write-host '** The Badger is taking a 10 second break to check his phone.'
write-host '** (Also, Windows is checking your DHCP lease.)'
Start-Sleep -Seconds 10
$ipv4 = (Get-NetIPAddress -InterfaceIndex $ii).IPv4Address
write-host '** Your network adapters ip address is now '$ipv4
if( $ipv4 -like '169*'){
    write-host ''
    write-host '** Since you have a 169 address, the DHCP lease needs to be renewed.'
    write-host '** The Badger is doing his best...'
    write-host '** (Executing ipconfig /renew...)'
    write-host ''
    ipconfig /renew $eths.name | out-null
    $ipv4 = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $ii).IPAddress
    write-host '** Your network adapters ip address is now '$ipv4
}
write-host ''
write-host '** Your current configuration looks like:'
netsh int ip show addresses $eths.name




$bayareatechpros = @"

https://www.bayareatechpros.com/ac1900-to-ac68u/

mtd-write2 FW_RT_AC68U_30043763626.trx linux
Perform NVRAM Reset, wait for reboot <5 mins
a. Power off router
b. Wait 10 seconds
c. Press and hold WPS button
d. Power up the router and continue to hold WPS button for 15-20 seconds until power LED starts blinking very quickly.
Reset PC IP back to default
Log in to router using 192.168.1.1 and the router is now an AC68U with 64MB jffs
username:/password is now: admin:admin
Enable SSH (see #10) and execute the code for fixing MTD5 partition that is listed below.
Ezlink: http://192.168.1.1/Advanced_System_Content.asp
You can now flash Asus, Merlin, Advanced Tomato, Tomato, and DD-WRT firmwares.
Code for fixing MTD5 partition so you can update to latest firmware:
(this is entered in Putty after enabling SSH on the router)

cat /dev/mtd5 > /jffs/mtd5_backup.bin
mkdir /tmp/asus_jffs
mount -t jffs2 /dev/mtdblock5 /tmp/asus_jffs
rm -rf /tmp/asus_jffs/*
sync && umount /tmp/asus_jffs
rm -rf /jffs/.sys/RT-AC68U
nvram unset fw_check && nvram commit && reboot

"@


#https://www.bleepingcomputer.com/news/microsoft/heres-how-to-enable-the-built-in-windows-10-openssh-client/
#https://man.openbsd.org/ssh
#scp scp://USERNAME@HOST:PORT//FILEPATH/file.txt ./
#ssh ssh://USERNAME@HOST:PORT

#https://devblogs.microsoft.com/scripting/using-powershell-to-find-connected-network-adapters/
# get-netadapter -physical | where status -eq 'up'
# (get-netadapter -physical | where status -eq 'up').ifIndex
# (get-netadapter -physical | where status -eq 'up').name
# Get-NetAdapter -physical | Where-Object { $_.Status -ne 'Disconnected' }
# Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex 7
# help Set-NetIPAddress -examples

#https://www.pdq.com/blog/using-powershell-to-set-static-and-dhcp-ip-addresses-part-1/
# Get-NetIPInterface -ifIndex 11 -AddressFamily IPv4
# Set-NetIPInterface -Dhcp Enabled
# New-NetIPAddress -InterfaceIndex 11 -IPAddress 10.10.10.10 -PrefixLength 24 -DefaultGateway 10.10.10.1


# https://stackoverflow.com/questions/13869182/how-to-get-the-default-gateway-from-powershell
# https://powershell.org/forums/topic/problem-with-showing-properties-of-netipconfiguration-object/
# http://techgenix.com/interacting-tcp-ip-through-powershell-part3/
