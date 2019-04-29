
****************************
** The Badger is on the move
****************************

** Host machine: Microsoft Windows NT 10.0.17134.0 (1803)
** TFTP state: Enabled
** This script is being run from: C:\Users\jason\Documents\asus-rebadger
** These *.trx files are in this directory:


    Directory: C:\Users\jason\Documents\asus-rebadger


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       11/11/2014   6:24 AM       30126080 FW_RT_AC68U_30043763626.trx
-a----        3/24/2019   3:41 PM       36818944 MERLIN_RT-AC68U_384.10_0.trx
-a----         8/5/2014   2:35 PM       16949248 TM-AC1900_3.0.0.4_376_1703-g0ffdbba.trx

** Proceeding without checking if all the files are present (!!!)



/========= MAIN MENU / INSTRUCTIONS ==============================
|  a) verify/select your ethernet adapter
|  b) set manual IP in subnet 29
|  ** Boot router into recovery mode:
|  **    turn on router while holding reset (> 2min)
|  c) Perform (D) and (E) together
|  d)    wait for router to return on subnet 29
|  e)    TFTP flash old Tmo FW via subnet
|  ** Enable SSH on router (Administration > System)
|  f) download Tmo CFE to local
|  ** Use that website and your CFE to create/download a new CFE
|  g) upload mod-CFE etc then write CFE and FW
|  ** Perform NVRAM reset
|  **    turn on router while holding WPS (~ 15sec)
|  h) set auto IP by DHCP
|  i) wait for router to return on subnet 1
|  j) secret sauce to clean MTD
|
|  NOTE: **Steps (G) thru (J) must be executed exactly
|        in order and without interuption. Repeat steps
|        F thru I if anything wasn't perfect.
|        **Step (G) assumes your IP is set in subnet-29
|        (step-B), and that the router is on, and is
|        actively responding (step-D).
|
|  X) show current network config
|  Y) set manual IP in subnet 1
|  Z) TFTP flash old Tmo FW via subnet 1
\=================================================================
   [History:  ]

Enter the letter for an operation: a

** BEFORE PROCEEDING...
**  make sure your computer is directly connected to
**  a YELLOW ethernet port (specifically #1) on the router.
**  AKA: don't be connected to the BLUE wan port.

Press Enter to continue...:
** The Badger sees these network adapters:



Name                      InterfaceDescription                    ifIndex Status       MacAddress             LinkSpeed
----                      --------------------                    ------- ------       ----------             ---------
Ethernet 5                Intel(R) Ethernet Connection (2) I219-V      11 Up           30-9C-23-88-0E-0C         1 Gbps



** Your network adapter is #11
** Your network adapters name is Ethernet 5
** Your current configuration looks like:

Configuration for interface "Ethernet 5"
    DHCP enabled:                         Yes
    IP Address:                           192.168.29.180
    Subnet Prefix:                        192.168.29.0/24 (mask 255.255.255.0)
    Default Gateway:                      192.168.29.1
    Gateway Metric:                       0
    InterfaceMetric:                      25


********** NEXT STEPS **********************************************************************
**
** Now that your ethernet adapter has been verified/selected, youll want a manual IP
** address (in subnet 29) because we will soon put the router into "recovery" mode.
**
** (While in recovery/miniCFE mode, the router is only running HTTP and TFTP services.
**  Note: DHCP is not one of those services, so it wont automatically give you an IP.)
**
********************************************************************************************

Press Enter to continue...:


/========= MAIN MENU / INSTRUCTIONS ==============================
|  a) verify/select your ethernet adapter
|  b) set manual IP in subnet 29
|  ** Boot router into recovery mode:
|  **    turn on router while holding reset (> 2min)
|  c) Perform (D) and (E) together
|  d)    wait for router to return on subnet 29
|  e)    TFTP flash old Tmo FW via subnet
|  ** Enable SSH on router (Administration > System)
|  f) download Tmo CFE to local
|  ** Use that website and your CFE to create/download a new CFE
|  g) upload mod-CFE etc then write CFE and FW
|  ** Perform NVRAM reset
|  **    turn on router while holding WPS (~ 15sec)
|  h) set auto IP by DHCP
|  i) wait for router to return on subnet 1
|  j) secret sauce to clean MTD
|
|  NOTE: **Steps (G) thru (J) must be executed exactly
|        in order and without interuption. Repeat steps
|        F thru I if anything wasn't perfect.
|        **Step (G) assumes your IP is set in subnet-29
|        (step-B), and that the router is on, and is
|        actively responding (step-D).
|
|  X) show current network config
|  Y) set manual IP in subnet 1
|  Z) TFTP flash old Tmo FW via subnet 1
\=================================================================
   [History: a, ]

Enter the letter for an operation: b

** (We use subnet 29 because when youre using T-Mo firmware, in recovery mode is hard-coded for that.)

** The Badger notes your current configuration is:

Name                      InterfaceDescription                    ifIndex Status       MacAddress             LinkSpeed
----                      --------------------                    ------- ------       ----------             ---------
Ethernet 5                Intel(R) Ethernet Connection (2) I219-V      11 Up           30-9C-23-88-0E-0C         1 Gbps


** Your network adapter is #11
** Your network adapters name is Ethernet 5
** Your current configuration looks like:

Configuration for interface "Ethernet 5"
    DHCP enabled:                         Yes
    IP Address:                           192.168.29.180
    Subnet Prefix:                        192.168.29.0/24 (mask 255.255.255.0)
    Default Gateway:                      192.168.29.1
    Gateway Metric:                       0
    InterfaceMetric:                      25


** The Badger is now attempting to set a manual IP: 192.168.29.xx...

**   99% chance you can ignore the above error, if there is one
**   99% chance you can ignore the above error, if there is one

** (Waiting for IPv4 address to finalize...)
** (Waiting for IPv4 address to finalize...)
** ...done. (Unless you saw some ugly powershell error.)
** Your current configuration looks like:

Configuration for interface "Ethernet 5"
    DHCP enabled:                         No
    IP Address:                           192.168.29.5
    Subnet Prefix:                        192.168.29.0/24 (mask 255.255.255.0)
    Default Gateway:                      192.168.29.1
    Gateway Metric:                       256
    InterfaceMetric:                      25


********** NEXT STEPS ***************************************************
**
** Now we are ready to put the router into recovery mode.
**
** It is kinda tricky, so when you choose (c), instructions will follow
**
*************************************************************************

Press Enter to continue...:


/========= MAIN MENU / INSTRUCTIONS ==============================
|  a) verify/select your ethernet adapter
|  b) set manual IP in subnet 29
|  ** Boot router into recovery mode:
|  **    turn on router while holding reset (> 2min)
|  c) Perform (D) and (E) together
|  d)    wait for router to return on subnet 29
|  e)    TFTP flash old Tmo FW via subnet
|  ** Enable SSH on router (Administration > System)
|  f) download Tmo CFE to local
|  ** Use that website and your CFE to create/download a new CFE
|  g) upload mod-CFE etc then write CFE and FW
|  ** Perform NVRAM reset
|  **    turn on router while holding WPS (~ 15sec)
|  h) set auto IP by DHCP
|  i) wait for router to return on subnet 1
|  j) secret sauce to clean MTD
|
|  NOTE: **Steps (G) thru (J) must be executed exactly
|        in order and without interuption. Repeat steps
|        F thru I if anything wasn't perfect.
|        **Step (G) assumes your IP is set in subnet-29
|        (step-B), and that the router is on, and is
|        actively responding (step-D).
|
|  X) show current network config
|  Y) set manual IP in subnet 1
|  Z) TFTP flash old Tmo FW via subnet 1
\=================================================================
   [History: a,b, ]

Enter the letter for an operation: c


********** YOUR PARTICIPATION NOW REQUIRED ****************************************
**
** 1. power-off the router using the pushbutton (on the back)
** 2. hold down the reset button (on the back)
**      --> note you wont be releasing it for 1-3 mins, until after you see a message like this:
**          "Transfer successful: 16949248 bytes in 62 second(s), 273374 bytes/s"
** 3. turn the router on using the pushbutton
** 4. NOW you can hit enter, here
**
***********************************************************************************

Press Enter to continue...:
** Waiting for the router to boot back up...
** [ 0] 0 pings in-a-row, so far
** [ 10] 9 pings in-a-row, so far
** [ 20] 19 pings in-a-row, so far
** It looks like it's back up now.
Immediately executing TFTP transfer via subnet 29...
Transfer successful: 16949248 bytes in 59 second(s), 287275 bytes/s


/========= MAIN MENU / INSTRUCTIONS ==============================
|  a) verify/select your ethernet adapter
|  b) set manual IP in subnet 29
|  ** Boot router into recovery mode:
|  **    turn on router while holding reset (> 2min)
|  c) Perform (D) and (E) together
|  d)    wait for router to return on subnet 29
|  e)    TFTP flash old Tmo FW via subnet
|  ** Enable SSH on router (Administration > System)
|  f) download Tmo CFE to local
|  ** Use that website and your CFE to create/download a new CFE
|  g) upload mod-CFE etc then write CFE and FW
|  ** Perform NVRAM reset
|  **    turn on router while holding WPS (~ 15sec)
|  h) set auto IP by DHCP
|  i) wait for router to return on subnet 1
|  j) secret sauce to clean MTD
|
|  NOTE: **Steps (G) thru (J) must be executed exactly
|        in order and without interuption. Repeat steps
|        F thru I if anything wasn't perfect.
|        **Step (G) assumes your IP is set in subnet-29
|        (step-B), and that the router is on, and is
|        actively responding (step-D).
|
|  X) show current network config
|  Y) set manual IP in subnet 1
|  Z) TFTP flash old Tmo FW via subnet 1
\=================================================================
   [History: a,b,c, ]

Enter the letter for an operation: d

** Waiting for router to enter recovery mode...
**   (If it takes > 40 sec, something went wrong)
** Waiting for the router to boot back up...
** [ 0] 1 pings in-a-row, so far
** [ 10] 11 pings in-a-row, so far
** [ 20] 21 pings in-a-row, so far
** It looks like it's back up now.


/========= MAIN MENU / INSTRUCTIONS ==============================
|  a) verify/select your ethernet adapter
|  b) set manual IP in subnet 29
|  ** Boot router into recovery mode:
|  **    turn on router while holding reset (> 2min)
|  c) Perform (D) and (E) together
|  d)    wait for router to return on subnet 29
|  e)    TFTP flash old Tmo FW via subnet
|  ** Enable SSH on router (Administration > System)
|  f) download Tmo CFE to local
|  ** Use that website and your CFE to create/download a new CFE
|  g) upload mod-CFE etc then write CFE and FW
|  ** Perform NVRAM reset
|  **    turn on router while holding WPS (~ 15sec)
|  h) set auto IP by DHCP
|  i) wait for router to return on subnet 1
|  j) secret sauce to clean MTD
|
|  NOTE: **Steps (G) thru (J) must be executed exactly
|        in order and without interuption. Repeat steps
|        F thru I if anything wasn't perfect.
|        **Step (G) assumes your IP is set in subnet-29
|        (step-B), and that the router is on, and is
|        actively responding (step-D).
|
|  X) show current network config
|  Y) set manual IP in subnet 1
|  Z) TFTP flash old Tmo FW via subnet 1
\=================================================================
   [History: a,b,c,d, ]

Enter the letter for an operation: x

** The Badger notes your current configuration is:

Name                      InterfaceDescription                    ifIndex Status       MacAddress             LinkSpeed
----                      --------------------                    ------- ------       ----------             ---------
Ethernet 5                Intel(R) Ethernet Connection (2) I219-V      11 Up           30-9C-23-88-0E-0C         1 Gbps


** Your network adapter is #11
** Your network adapters name is Ethernet 5
** Your current configuration looks like:

Configuration for interface "Ethernet 5"
    DHCP enabled:                         No
    IP Address:                           192.168.29.5
    Subnet Prefix:                        192.168.29.0/24 (mask 255.255.255.0)
    Default Gateway:                      192.168.29.1
    Gateway Metric:                       256
    InterfaceMetric:                      25




/========= MAIN MENU / INSTRUCTIONS ==============================
|  a) verify/select your ethernet adapter
|  b) set manual IP in subnet 29
|  ** Boot router into recovery mode:
|  **    turn on router while holding reset (> 2min)
|  c) Perform (D) and (E) together
|  d)    wait for router to return on subnet 29
|  e)    TFTP flash old Tmo FW via subnet
|  ** Enable SSH on router (Administration > System)
|  f) download Tmo CFE to local
|  ** Use that website and your CFE to create/download a new CFE
|  g) upload mod-CFE etc then write CFE and FW
|  ** Perform NVRAM reset
|  **    turn on router while holding WPS (~ 15sec)
|  h) set auto IP by DHCP
|  i) wait for router to return on subnet 1
|  j) secret sauce to clean MTD
|
|  NOTE: **Steps (G) thru (J) must be executed exactly
|        in order and without interuption. Repeat steps
|        F thru I if anything wasn't perfect.
|        **Step (G) assumes your IP is set in subnet-29
|        (step-B), and that the router is on, and is
|        actively responding (step-D).
|
|  X) show current network config
|  Y) set manual IP in subnet 1
|  Z) TFTP flash old Tmo FW via subnet 1
\=================================================================
   [History: a,b,c,d,x, ]

Enter the letter for an operation: f

** In a moment, you will TWICE be prompted to type a password.
** This password is "password".
Press Enter to continue...:
Oh, because I couldn't think of a(n easy) better way, this script will delete your ~/.ssh/* if you proceed
This won't matter to 99.99% of people, including people who don't know what this is. Proceed?
Press Enter to continue...:
Warning: Permanently added '192.168.29.1' (RSA) to the list of known hosts.
admin@192.168.29.1's password:
drwx------    3 admin    root            80 Dec 31 16:02 .
drwxr-xr-x    3 admin    root            60 Dec 31  1969 ..
drwx------    2 admin    root            60 Dec 31 16:02 .ssh
-rw-rw-rw-    1 admin    root        524288 Dec 31 16:02 original_cfe.bin
admin@192.168.29.1's password:
original_cfe.bin                                                                                                                                 100%  512KB 512.0KB/s   00:00





/========= MAIN MENU / INSTRUCTIONS ==============================
|  a) verify/select your ethernet adapter
|  b) set manual IP in subnet 29
|  ** Boot router into recovery mode:
|  **    turn on router while holding reset (> 2min)
|  c) Perform (D) and (E) together
|  d)    wait for router to return on subnet 29
|  e)    TFTP flash old Tmo FW via subnet
|  ** Enable SSH on router (Administration > System)
|  f) download Tmo CFE to local
|  ** Use that website and your CFE to create/download a new CFE
|  g) upload mod-CFE etc then write CFE and FW
|  ** Perform NVRAM reset
|  **    turn on router while holding WPS (~ 15sec)
|  h) set auto IP by DHCP
|  i) wait for router to return on subnet 1
|  j) secret sauce to clean MTD
|
|  NOTE: **Steps (G) thru (J) must be executed exactly
|        in order and without interuption. Repeat steps
|        F thru I if anything wasn't perfect.
|        **Step (G) assumes your IP is set in subnet-29
|        (step-B), and that the router is on, and is
|        actively responding (step-D).
|
|  X) show current network config
|  Y) set manual IP in subnet 1
|  Z) TFTP flash old Tmo FW via subnet 1
\=================================================================
   [History: a,b,c,d,x,f, ]

Enter the letter for an operation: g

** In a moment, you will again be twice prompted to type a password.
** This password is "password".
Press Enter to continue...:

** The Badger is gonna...
** First, upload files via SCP:
**    * new_cfe.bin
**    * mtd-write
**    * FW_RT_AC68U_30043763626.trx
** Then, list files, install bootloader, and install FW_RT_AC68U_30043763626.trx:
**    > chmod 777 mtd-write
**    > ls -al
**    > ./mtd-write -i new_cfe.bin -d boot
**    > mtd-write2 FW_RT_AC68U_30043763626.trx linux

Oh, because I couldn't think of a(n easy) better way, this script will delete your ~/.ssh/* if you proceed
This won't matter to 99.99% of people, including people who don't know what this is. Proceed?
Press Enter to continue...:
** Now copying 3 files to the router via SCP...
**   (new_cfe.bin, mtd-write, FW_RT_AC68U_30043763626.trx)
Warning: Permanently added '192.168.29.1' (RSA) to the list of known hosts.
admin@192.168.29.1's password:
new_cfe.bin                                                                                                                                      100%  226KB 226.5KB/s   00:00
mtd-write                                                                                                                                        100%  511KB 511.1KB/s   00:00
FW_RT_AC68U_30043763626.trx                                                                                                                      100%   29MB   4.1MB/s   00:07
** ...SCP copy complete.

** Now listing files, installing bootloader, and installing FW_RT_AC68U_30043763626.trx...
**   (chmod 777 mtd-write -->
**      ls -al -->
**         ./mtd-write -i new_cfe.bin -d boot -->
**             mtd-write2 FW_RT_AC68U_30043763626.trx linux)

admin@192.168.29.1's password:
drwx------    3 admin    root           140 Dec 31 16:06 .
drwxr-xr-x    3 admin    root            60 Dec 31  1969 ..
drwx------    2 admin    root            60 Dec 31 16:02 .ssh
-rw-rw-rw-    1 admin    root      30126080 Dec 31 16:06 FW_RT_AC68U_30043763626.trx
-rwxrwxrwx    1 admin    root        523364 Dec 31 16:06 mtd-write
-rw-rw-rw-    1 admin    root        231923 Dec 31 16:06 new_cfe.bin
-rw-rw-rw-    1 admin    root        524288 Dec 31 16:02 original_cfe.bin
linux: CRC OK
** (Should be a CRC verification after mtd-write2)

********** YOUR PARTICIPATION NOW REQUIRED ******************************
**
** Now that the router has newer Asus firmware, we MUST reset its NVRAM
**
**   1. Power-off router using the pushbutton (on the back)
**   2. Wait 10 seconds
**   3. Press and hold WPS button
**   4. Power-on the router and continue to hold WPS button for 15-20
**      seconds until power LED starts blinking very quickly
**   5. release the WPS button, and the router should reboot itself
**   6. you do not need to wait for the router to fully reboot to proceed
**
*************************************************************************


********** NEXT STEPS ***************************************************
**
** At the main menu, use (h) to set your ethernet adapter to pull
** an automatic IP using DHCP.
**
** Then you can optionally use (i) to see when the router is back online.
** After that, you will need to (again) enable SSH on the router.
**
** Note: now that you are using Asus firmware, that subnet-29 garbage is
** history. The default credentials have also changed. Its IP address
** will now be 192.168.1.1 with admin/admin.
**                                      ^--- not "password" anymore
**
*************************************************************************

Press Enter to continue...:


/========= MAIN MENU / INSTRUCTIONS ==============================
|  a) verify/select your ethernet adapter
|  b) set manual IP in subnet 29
|  ** Boot router into recovery mode:
|  **    turn on router while holding reset (> 2min)
|  c) Perform (D) and (E) together
|  d)    wait for router to return on subnet 29
|  e)    TFTP flash old Tmo FW via subnet
|  ** Enable SSH on router (Administration > System)
|  f) download Tmo CFE to local
|  ** Use that website and your CFE to create/download a new CFE
|  g) upload mod-CFE etc then write CFE and FW
|  ** Perform NVRAM reset
|  **    turn on router while holding WPS (~ 15sec)
|  h) set auto IP by DHCP
|  i) wait for router to return on subnet 1
|  j) secret sauce to clean MTD
|
|  NOTE: **Steps (G) thru (J) must be executed exactly
|        in order and without interuption. Repeat steps
|        F thru I if anything wasn't perfect.
|        **Step (G) assumes your IP is set in subnet-29
|        (step-B), and that the router is on, and is
|        actively responding (step-D).
|
|  X) show current network config
|  Y) set manual IP in subnet 1
|  Z) TFTP flash old Tmo FW via subnet 1
\=================================================================
   [History: a,b,c,d,x,f,g, ]

Enter the letter for an operation: h

** The Badger is now attempting to get an IP automatically through DHCP...

** If there is a "NetRoute" error above... 99% chance you can just ignore it.

** (Waiting for IPv4 address to set...)
** (Waiting for IPv4 address to set...)
** (Waiting for IPv4 address to set...)
** (Waiting for IPv4 address to set...)
** The Badger is taking a 10 second break to check his phone.
** (Also, Windows is checking your DHCP lease.)
** Your network adapters ip address is now  192.168.1.210

** Your current configuration looks like:

Configuration for interface "Ethernet 5"
    DHCP enabled:                         Yes
    IP Address:                           192.168.1.210
    Subnet Prefix:                        192.168.1.0/24 (mask 255.255.255.0)
    Default Gateway:                      192.168.1.1
    Gateway Metric:                       0
    InterfaceMetric:                      25



/========= MAIN MENU / INSTRUCTIONS ==============================
|  a) verify/select your ethernet adapter
|  b) set manual IP in subnet 29
|  ** Boot router into recovery mode:
|  **    turn on router while holding reset (> 2min)
|  c) Perform (D) and (E) together
|  d)    wait for router to return on subnet 29
|  e)    TFTP flash old Tmo FW via subnet
|  ** Enable SSH on router (Administration > System)
|  f) download Tmo CFE to local
|  ** Use that website and your CFE to create/download a new CFE
|  g) upload mod-CFE etc then write CFE and FW
|  ** Perform NVRAM reset
|  **    turn on router while holding WPS (~ 15sec)
|  h) set auto IP by DHCP
|  i) wait for router to return on subnet 1
|  j) secret sauce to clean MTD
|
|  NOTE: **Steps (G) thru (J) must be executed exactly
|        in order and without interuption. Repeat steps
|        F thru I if anything wasn't perfect.
|        **Step (G) assumes your IP is set in subnet-29
|        (step-B), and that the router is on, and is
|        actively responding (step-D).
|
|  X) show current network config
|  Y) set manual IP in subnet 1
|  Z) TFTP flash old Tmo FW via subnet 1
\=================================================================
   [History: a,b,c,d,x,f,g,h, ]

Enter the letter for an operation: j


********** YOUR PARTICIPATION NOW REQUIRED ***************************************
**
** If you haven't done so already, because the router has been reset
** with newer Asus firmware, we must enable SSH again:
**
**   1. go to http://192.168.1.1/Advanced_System_Content.asp
**   2. sign in as admin/admin (the asus firmware default)
**   3. go to "administration" and click the "system" tab
**   4. enable SSH in the "SSH Daemon" section
**   5. save/apply the configuration change
**   6. One now should be able to ssh to admin:password@192.168.1.1
**
**********************************************************************************

Press Enter to continue...:
Oh, because I couldn't think of a(n easy) better way, this script will delete your ~/.ssh/* if you proceed
This won't matter to 99.99% of people, including people who don't know what this is. Proceed?
Press Enter to continue...:
** You will once again be asked, just once this time, to enter a password.
** The password is now "admin"
Warning: Permanently added '192.168.1.1' (RSA) to the list of known hosts.
admin@192.168.1.1's password:
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



/========= MAIN MENU / INSTRUCTIONS ==============================
|  a) verify/select your ethernet adapter
|  b) set manual IP in subnet 29
|  ** Boot router into recovery mode:
|  **    turn on router while holding reset (> 2min)
|  c) Perform (D) and (E) together
|  d)    wait for router to return on subnet 29
|  e)    TFTP flash old Tmo FW via subnet
|  ** Enable SSH on router (Administration > System)
|  f) download Tmo CFE to local
|  ** Use that website and your CFE to create/download a new CFE
|  g) upload mod-CFE etc then write CFE and FW
|  ** Perform NVRAM reset
|  **    turn on router while holding WPS (~ 15sec)
|  h) set auto IP by DHCP
|  i) wait for router to return on subnet 1
|  j) secret sauce to clean MTD
|
|  NOTE: **Steps (G) thru (J) must be executed exactly
|        in order and without interuption. Repeat steps
|        F thru I if anything wasn't perfect.
|        **Step (G) assumes your IP is set in subnet-29
|        (step-B), and that the router is on, and is
|        actively responding (step-D).
|
|  X) show current network config
|  Y) set manual IP in subnet 1
|  Z) TFTP flash old Tmo FW via subnet 1
\=================================================================
   [History: a,b,c,d,x,f,g,h,j, ]

Enter the letter for an operation: i

** Waiting for the router to boot back up...
**   (The Badger will wait up to 5 full minutes this time, reporting every 10 tries)
** [ 0] 0 pings in-a-row, so far
** [ 10] 0 pings in-a-row, so far
** [ 20] 0 pings in-a-row, so far



/========= MAIN MENU / INSTRUCTIONS ==============================
|  a) verify/select your ethernet adapter
|  b) set manual IP in subnet 29
|  ** Boot router into recovery mode:
|  **    turn on router while holding reset (> 2min)
|  c) Perform (D) and (E) together
|  d)    wait for router to return on subnet 29
|  e)    TFTP flash old Tmo FW via subnet
|  ** Enable SSH on router (Administration > System)
|  f) download Tmo CFE to local
|  ** Use that website and your CFE to create/download a new CFE
|  g) upload mod-CFE etc then write CFE and FW
|  ** Perform NVRAM reset
|  **    turn on router while holding WPS (~ 15sec)
|  h) set auto IP by DHCP
|  i) wait for router to return on subnet 1
|  j) secret sauce to clean MTD
|
|  NOTE: **Steps (G) thru (J) must be executed exactly
|        in order and without interuption. Repeat steps
|        F thru I if anything wasn't perfect.
|        **Step (G) assumes your IP is set in subnet-29
|        (step-B), and that the router is on, and is
|        actively responding (step-D).
|
|  X) show current network config
|  Y) set manual IP in subnet 1
|  Z) TFTP flash old Tmo FW via subnet 1
\=================================================================
   [History: a,b,c,d,x,f,g,h,j,i, ]

Enter the letter for an operation: x

** The Badger notes your current configuration is:

Name                      InterfaceDescription                    ifIndex Status       MacAddress             LinkSpeed
----                      --------------------                    ------- ------       ----------             ---------
Ethernet 5                Intel(R) Ethernet Connection (2) I219-V      11 Up           30-9C-23-88-0E-0C         1 Gbps


** Your network adapter is #11
** Your network adapters name is Ethernet 5
** Your current configuration looks like:

Configuration for interface "Ethernet 5"
    DHCP enabled:                         Yes
    IP Address:                           192.168.1.210
    Subnet Prefix:                        192.168.1.0/24 (mask 255.255.255.0)
    Default Gateway:                      192.168.1.1
    Gateway Metric:                       0
    InterfaceMetric:                      25




/========= MAIN MENU / INSTRUCTIONS ==============================
|  a) verify/select your ethernet adapter
|  b) set manual IP in subnet 29
|  ** Boot router into recovery mode:
|  **    turn on router while holding reset (> 2min)
|  c) Perform (D) and (E) together
|  d)    wait for router to return on subnet 29
|  e)    TFTP flash old Tmo FW via subnet
|  ** Enable SSH on router (Administration > System)
|  f) download Tmo CFE to local
|  ** Use that website and your CFE to create/download a new CFE
|  g) upload mod-CFE etc then write CFE and FW
|  ** Perform NVRAM reset
|  **    turn on router while holding WPS (~ 15sec)
|  h) set auto IP by DHCP
|  i) wait for router to return on subnet 1
|  j) secret sauce to clean MTD
|
|  NOTE: **Steps (G) thru (J) must be executed exactly
|        in order and without interuption. Repeat steps
|        F thru I if anything wasn't perfect.
|        **Step (G) assumes your IP is set in subnet-29
|        (step-B), and that the router is on, and is
|        actively responding (step-D).
|
|  X) show current network config
|  Y) set manual IP in subnet 1
|  Z) TFTP flash old Tmo FW via subnet 1
\=================================================================
   [History: a,b,c,d,x,f,g,h,j,i,x, ]

Enter the letter for an operation:
