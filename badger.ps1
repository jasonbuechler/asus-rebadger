
##########################################################
##
## IF YOU OPENED THIS SCRIPT IN "PowerShell ISE"...
##    (as opposed to 'executing' it)
##       ...HIT THE GREEN 'PLAY/TRIANGLE', ABOVE.
##
##########################################################
## 
## The Badger v2.2.0 by Jason Buechler
##

write-host ''
write-host '****************************'
write-host '** The Badger is on the move'
write-host '****************************'
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
# gather info on environment
# mostly for any future debugging
#
$winver = [Environment]::OSVersion.VersionString
$relid = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId

# just in case the script was executed when pwd != $PSScriptRoot
#   e.g.: PS C:\Users\user1 powershell Downloads\badger.ps1
cd $PSScriptRoot
$pwd = pwd

$tftpstate = (Get-WindowsOptionalFeature -FeatureName "TFTP" -online).State

$opts376_1703 = '-oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false'
$opts376_3626 = '-oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 -oStrictHostKeyChecking=false'

write-host "** Host machine: $winver ($relid)"
write-host "** TFTP state: $tftpstate"
write-host "** This script is being run from: $pwd"
write-host '** These *.trx files are in this directory:'
ls *trx
write-host ''
write-host '** Proceeding without checking if all the files are present (!!!)'
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
        write-host -foregroundcolor green $c1
        pause
        . '.\bits\wait for router to return on subnet 29.ps1'
        . '.\bits\TFTP flash old Tmo FW via subnet 29.ps1'
    }
    d{ # wait for router to return on subnet 29
        #looks like i'll have to add some more logic for the short window
        write-host '** Waiting for router to enter recovery mode...'
        write-host '**   (If it takes > 40 sec, something went wrong)'
        . '.\bits\wait for router to return on subnet 29.ps1'
    }
    e{ # TFTP flash old Tmo FW via subnet 29 
        write-host $e1
        . '.\bits\TFTP flash old Tmo FW via subnet 29.ps1'
        write-host $e2
		write-host -foregroundcolor green $e3
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
        . '.\bits\wait for router to return on subnet 1.ps1'
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

    z{ # TFTP flash old Tmo FW via subnet 1
        . '.\bits\TFTP flash old Tmo FW via subnet 1.ps1'
    }

    '[a-jx-zA-JX-Z]'{ $history += "$bit," }
}}



Exit
