# The Badger v2.3.0 by Jason Buechler

<a href="http://www.youtube.com/watch?feature=player_embedded&v=J7SYNOZQ504" target="_blank"><img src="https://github.com/jasonbuechler/asus-rebadger/blob/master/github_resources/youtube-thumb.png?raw=true" alt="badger v220 in action" width="480" height="360" border="10" /></a>

Video demo: https://www.youtube.com/watch?v=J7SYNOZQ504

REQUIREMENTS:
* A relatively recently updated Windows 10 computer
* Administrator privileges for the user running the script
* All network adapters, besides one ethernet, to be disabled/disconnected
* __Several files that I'm not hosting or including because I have no idea what the licenses are and am not interested in taking that obligation on... BUT, they're easy to find. Grab them from this famous instructional page:__ https://www.bayareatechpros.com/ac1900-to-ac68u/

MAKE IT DO:
* verify you've collected all the files in one place (see below)
* right click badger.ps1 and "Run with PowerShell"
* if it opens in PowerShell ISE, you'll see the green-text note at the top saying to run it using the green play/triangle button
* however you run it, if it determines you need to do so, it will alert you that it will relaunch itself properly 
 
NECESSARY FILES: 
* The Badger's scripts -----> https://github.com/jasonbuechler/asus-rebadger/releases
  * badger.ps1 
  * bits/*.ps1 
* downloads from bayareatechpros
  * ``FW_RT_AC68U_30043763626.trx ........... (MD5: C9D544EFD51DAD31C7A0E533DBD2005B)`` 
  * ``mtd-write ............................. (MD5: DC162789E82618AC4E0F6A252A083F8F)`` 
  * ``TM-AC1900_3.0.0.4_376_1703-g0ffdbba.trx (MD5: E617E8E4326D61EF7DECC751FA3D40D4)`` 


# Demo

## Easily handles the difficult "recovery mode" operation to revert to old T-Mo firmware
![tftp-downgrade](https://github.com/jasonbuechler/asus-rebadger/blob/master/github_resources/badger220-tftp-downgrade.gif?raw=true)

## Handling upload of your CFE file and flashing of stock Asus firmware
![cfe-and-fw-upload](https://github.com/jasonbuechler/asus-rebadger/blob/master/github_resources/badger220-cfe-and-fw-upload.gif?raw=true)

## Does all the "secret commands" to fix the MTD5 partition and allow unlocked firmware
![secret-sauce-and-unlocked-firmware](https://github.com/jasonbuechler/asus-rebadger/blob/master/github_resources/badger220-secret-sauce-and-unlocked-firmware.gif?raw=true)

...And basically everything else too.
