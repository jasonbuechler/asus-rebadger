$menu = @"

/========= MAIN MENU / INSTRUCTIONS ==============================
|  A) verify/select your ethernet adapter
|  B) set manual IP in subnet 29
|  ** Boot router into recovery mode:
|  **    turn on router while holding reset (> 2min)
|  C) Perform (D) and (E) together
|  D)    wait for router to return on subnet 29
|  E)    TFTP flash old Tmo FW via subnet 
|  ** Enable SSH on router (Administration > System)
|  F) download Tmo CFE to local
|  ** Use your CFE and cfeditor.pipeline.sh to make new_cfe.bin
|  G) upload mod'd CFE & etc then "write" CFE and FW
|  ** Perform NVRAM reset
|  **    turn on router while holding WPS (~ 15sec)
|  H) set manual IP in subnet 1
|  I) wait for router to return on subnet 1
|  ** Enable SSH on router (again)
|  J) secret sauce to clean MTD
|  K) set auto IP by DHCP
|
|  NOTE: **Steps (G) thru (J) must be executed exactly
|        in order and without interuption. Repeat those
|        steps if anything wasn't perfect.
|
|  X) show current network config
|  Z) TFTP flash old Tmo FW via subnet 1
\=================================================================

"@




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
** Remember: youll probably see nothing happening for 2 full agonizing minutes.
** Keep holding that reset button until you see the xfer is complete.

"@

$e2 = @"

                    ^^^^^^                                                 <
                THIS IS THE TFTP RESULT!                                   <
-----------------------------------------------------                      <
                                                                           <
** The TFTP step is over.                                                  <
** If all went well, the router should be rebooting right now.             <
**                                                                         <
** You'll know it's fully rebooted when both 2.4 & 5ghz wifi LEDs are on.  <

"@




$e3 = @"

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

********** YOUR PARTICIPATION NOW REQUIRED ***************************************
**                                                                                            
** The Badger should have just downloaded your original bootloader 
** (original_cfe.bin) to the same directory as everything else.
** Now you need to create a modified CFE using it...
**                                            
**   1. go to https://cfeditor.pipeline.sh/
**   2. click the "up arrow" under "original cfe"
**   3. select "1.0.2.0 US" under "source cfe" 
**      (you can do more advanced ones later)            
**   4. click the "down arrow" under "target cfe" to download
**   5. move the downloaded file to the same folder as badger.ps1  
**   6. rename that downloaded file to "new_cfe.bin" 
**      (make absolutely sure it's not named "new_cfe.bin.bin" or something)
**                                            
** The Badger can now upload all the goodies to the router and flash the FW.
**
**********************************************************************************

"@






$g1 = @"

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


********** NEXT STEPS *****************************************************
** 
** Next: Using steps (H) and (I) you will set a manual IP in subnet 1
** and wait for the router to reboot, so you can (again) enable SSH
** access. If you need the instructions for doing that, they will be  
** shown the top of the "secret sauce to clean MTD" step. 
**
**
** Note: now that you are using Asus firmware and have reset the NVRAM  
** to clear settings... that subnet-29 garbage is history. The default
** credentials have also changed. Its IP address will now be:
**            192.168.1.1 using admin/admin.
**                                      ^--- not "password" anymore   
**                                      
*************************************************************************

"@





$j1 = @"

********** YOUR PARTICIPATION NOW REQUIRED ***************************************
**                                                                                            
** If you haven't done so already, because the router has been reset 
** with newer (Asus) firmware, we must enable SSH again:
**                                            
**   1. go to http://192.168.1.1/Advanced_System_Content.asp
**   2. sign in as admin/admin (the asus firmware default)
**   3. go to "administration" and click the "system" tab                
**   4. enable SSH in the "SSH Daemon" section
**   5. save/apply the configuration change   
**   6. One now should be able to ssh to admin:admin@192.168.1.1    
**   7. The Badger will SSH in to add the secret sauce when you hit Enter, below
**                                            
**********************************************************************************


********** NEXT STEPS ************************************************************
**   
** Congrats, you're probably done at this point!
** And you should now reset your ethernet adapter back to DHCP using
** step (K) at the main menu. You can ignore steps (X)&(Z).
**
** ...but if something went wrong... scan through the console log and
** see if there is anything obviously wrong. If you don't see
** anything suspect, you should probably just do steps (G)-(J) again.
**                                      
**********************************************************************************

"@



