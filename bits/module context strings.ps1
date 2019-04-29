$a1 = @"

********** NEXT STEPS **********************************************************************
**
** Now that your ethernet adapter has been verified/selected, youll want a manual IP
** address (in subnet 29) because we will soon put the router into "recovery" mode.
** 
** (While in recovery/miniCFE mode, the router is only running HTTP and TFTP services.
**  Note: DHCP is not one of those services, so it wont automatically give you an IP.)
**
********************************************************************************************

"@





$b1 = @"

********** NEXT STEPS ***************************************************
**                                      
** Now we are ready to put the router into recovery mode.
**                                      
** It is kinda tricky, so when you choose (c), instructions will follow
**                                      
*************************************************************************

"@





$c1 = @"

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

"@




$e1 = @"

** Beginning TFTP transfer!!'
** Remember: youll probably see nothing happening for 2 full agonizing minutes.'
** Keep holding that reset button until you see the xfer is complete.'

"@

$e2 = @"
					^^^^^^
				THIS IS THE TFTP RESULT!
-----------------------------------------------------

** The TFTP step is over.
** If all went well, the router is probably rebooting at this moment.
** 
** You'll know it's fully rebooted when both 2.4 & 5ghz wifi LEDs are on.


********** YOUR PARTICIPATION NOW REQUIRED ***************************************
**                                                                                            
** Now that the router has older firmware with better options, we must enable SSH:
**                                            
**   1. go to http://192.168.29.1/Advanced_System_Content.asp
**   2. sign in as admin/password (the t-mo firmware default)
**   3. go to "administration" and click the "system" tab                
**   4. enable SSH in the "SSH Daemon" section
**   5. save/apply the configuration change   
**   6. One now should be able to ssh to admin:password@192.168.29.1    
**                                            
**********************************************************************************

"@





$f1 = @"



"@




$g1 = @"

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

"@




$g2 = @"

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

"@





$j1 = @"

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

"@



