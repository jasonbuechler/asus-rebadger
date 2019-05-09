# previously selecting your network adapter is now mandatory
if(-not $ii){
    write-host "You need to select your network adapter before you can do this."
    write-host "  (use menu option A)"
    pause
    Exit
}

# get router IP from current IP
$ipv4 = (Get-NetIPAddress -InterfaceIndex $ii).ipv4address
$ipv4 = "$ipv4".trim()
$gw = $ipv4 -replace "\.\d+$",".1"


# if the gateway ends in .29.1 let's assume we're specifically
# waiting for the TFTP window to open (until future improvements heh)
if($gw -match "\.29\.1$"){
	$piar = 0
	$threshold = 3
	$limit = 40 #should be 40-ish because the TFTP window closes fast
}else{
	$longwait = $True
	$piar = 0
	$threshold = 20
	$limit = 300 
}

write-host '** Waiting for the router to boot back up...'
write-host '**   (The Badger will wait up to 5 full minutes this time, reporting every 10 tries)'
$piar = 0
for($i=0; $i -le $limit; $i++){
	# Annoyingly, without a -TimeoutSeconds parameter, it seems to take 2-5 seconds 
	# to expire which means 10+ seconds per 5 pings. Correlarely, a successful ping
	# will take <1ms and basically instantly initiate another ping.
    if( test-connection -ComputerName $gw -Quiet -Count 1 ) { 
        $piar++ 
		Start-Sleep -Seconds 1 
    }else{ 
		$piar = 0	
	}
	
	if((-not $longwait) -or (($i % 5) -eq 0)){ #if we're not expecting many pings, or every 5th ping
		write-host "** [ $i ] $piar pings in-a-row, so far"
	}
	
    if($piar -gt $threshold){ 
		write-host ''
        write-host "** It looks like it's back up now." -foregroundcolor green
		write-host ''
        break 
    }
}

$annoyingaf = @"
	DIFFERENT VERSIONS OF POWERSHELL HAVE DIFFERENT PING TOOLS ! :-|

	https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/test-connection?view=powershell-5.1
		-TimeToLive
			Specifies the maximum times a packet can be forwarded. For every hop in gateways, routers etc. the TimeToLive 
			value is decreased by one. At zero the packet is discarded and an error is returned. The default value 
			(in Windows) is 128. 
			Aliases: TTL
			
	https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/test-connection?view=powershell-6
		-MaxHops
			Sets the maximum number of hops that an ICMP request message can be sent. The default value is controlled by 
			the operating system. The default value for Windows 10 is 128 hops. 
			Aliases: TTL
		-TimeoutSeconds
			Sets the timeout value for the test. The test fails if a response is not received before the timeout expires.
	
	see also: http://www.happysysadm.com/2017/02/from-test-connection-to-one-line-long.html
"@