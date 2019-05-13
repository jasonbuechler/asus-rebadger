
#####################################################################
##
## IF YOU OPENED THIS SCRIPT IN NOTEPAD...
##       ...close Notepad, right-click it, and "Run with PowerShell"
##
## IF YOU OPENED THIS SCRIPT IN "PowerShell ISE"...
##    (as opposed to 'executing' it)
##       ...HIT THE GREEN 'PLAY/TRIANGLE', ABOVE.
##
#####################################################################
## 
## The Badger v2.5.0 by Jason Buechler
##

write-host ''
write-host '*****************************                        '
write-host '** The Badger is on the move                   v2.5.0'
write-host '*****************************                        '
write-host ''



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
# Gather/report info on the current running environment (mostly for any future 
# debugging) ...and prepare the environment where necessary.
#
$pwd = $PSScriptRoot								# eg: PS C:\Users\user1\Downloads\badger230\badger.ps1
set-location $pwd									# powershell-native utils use this
[Environment]::CurrentDirectory = $pwd				# .net-native utils use this (aka IO.FILE read/write)
$winver = [Environment]::OSVersion.VersionString	# full windows version
$relid = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId # feature update
$tftpstate = (Get-WindowsOptionalFeature -FeatureName "TFTP" -online).State	# is TFTP enabled?
if($tftpstate -ne 'Enabled'){ # if TFTP isn't enabled, try enabling and check again
    write-host "** The TFTP 'windows feature' isn't enabled: Attempting to enable TFTP now..." -foregroundcolor yellow
    Enable-WindowsOptionalFeature -Online -FeatureName "TFTP" -all # surprisingly easy/simple command to enable
    $tftpstate = (Get-WindowsOptionalFeature -FeatureName "TFTP" -online).State # check again to verify tftp is enabled
    if($tftpstate -ne 'Enabled'){
		write-host ''
        write-host '** Couldnt enable TFTP feature!!!                 <' -backgroundcolor red
        write-host '** TFTP is necessary to escape tmo firmware.      <' -backgroundcolor red
		write-host ''
		write-host '** Try manually enabling it: www.thewindowsclub.com/enable-tftp-windows-10' -foregroundcolor yellow
		write-host ''
        pause
        Exit
    }else{
        write-host "** The TFTP 'windows feature' was successfully enabled." -foregroundcolor green
    }
}
write-host -foregroundcolor yellow "** Host machine: $winver ($relid)"
write-host -foregroundcolor yellow "** TFTP state: $tftpstate"
write-host -foregroundcolor yellow "** This script is being run from: $pwd"
write-host -foregroundcolor yellow "** PowerShell .net CD: $([Environment]::CurrentDirectory)"
write-host -foregroundcolor yellow '** These *.trx files are in this directory:'
ls *trx
write-host ''
write-host -foregroundcolor yellow '** Proceeding without checking if all the files are present (!!!)'
write-host ''



# load strings for module context
. '.\bits\module context strings.ps1'

$history = ''
while(1){ 
    write-host -foregroundColor yellow $menu
    write-host "   [History: $history ]"
    write-host ""
    $bit = Read-Host -Prompt "Enter the letter for an operation"
    if($bit){ $bit = $bit.substring(0,1) }
    write-host ''
Switch -regex ($bit){
    a{ # verify/select your ethernet adapter

        . '.\bits\select ethernet adapter.ps1'
		. '.\bits\show current network config.ps1' # show current network config (also menu X)
        write-host -foregroundcolor green $a1
        pause

    }
    b{ # set manual IP in subnet 29
        write-host '** (We use subnet 29 because when youre using T-Mo firmware, in recovery mode is hard-coded for that.)'
        write-host ''
        . '.\bits\set manual IP in subnet 29.ps1'
        write-host -foregroundcolor green $b1
        pause
    }
    c{ # chain D and E 
        write-host -foregroundcolor green $c1 #chain instructions
        pause
		
		
		#this part is a copy of switch 'd'	
		write-host '** Waiting for router to enter recovery mode...'
        write-host '**   (If it takes > 40 sec, something went wrong)'
        . '.\bits\wait for router to return on current subnet.ps1'

		
		#this part is a copy of switch 'e'
        write-host $e1 # start tftp + 2 agonizing mins
        . '.\bits\TFTP flash old Tmo FW via current subnet.ps1'
		write-host -foregroundcolor green $e3 # enable ssh instructions
        pause
    }
    d{ # wait for router to return on current subnet
        #looks like i'll have to add some more logic for the short window
        write-host '** Waiting for router to enter recovery mode...'
        write-host '**   (If it takes > 40 sec, something went wrong)'
        . '.\bits\wait for router to return on current subnet.ps1'
    }
    e{ # TFTP flash old Tmo FW via *current* subnet 
        write-host $e1 # start tftp + 2 agonizing mins
        . '.\bits\TFTP flash old Tmo FW via current subnet.ps1'
		write-host -foregroundcolor green $e3 # enable ssh instructions
        pause
    }
    f{ # download Tmo CFE to local

        . '.\bits\download Tmo CFE to local.ps1'
        write-host -foregroundcolor green $f1
		pause
		
    }
    g{ # upload mod-CFE etc then write CFE and FW

        . '.\bits\upload mod-CFE etc then write CFE and FW.ps1'
        write-host -foregroundcolor green $g1
        pause
		
    }
	
	h{ # set manual IP in subnet 1
        . '.\bits\set manual IP in subnet 1.ps1'
    }
	
    i{
        . '.\bits\wait for router to return on current subnet.ps1'
    }
	
    j{
        write-host -foregroundcolor green $j1
        pause
        . '.\bits\secret sauce to clean MTD.ps1'
    }

    k{ # set auto IP by dhcp
        . '.\bits\set auto IP by DHCP.ps1'
    }

	
	
	
    x{ # show current network config
        . '.\bits\show current network config.ps1'
    }
	
	y{ # personalize a new CFE.bin
		write-host -foregroundcolor green $y1
		pause
		. '.\bits\cfe personalizer.ps1'
	}

    '[a-jx-zA-JX-Z]'{ $history += "$bit," }
}}



Exit
