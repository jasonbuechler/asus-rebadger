write-host '** Waiting for the router to boot back up...'
write-host '**   (The Badger will wait up to 5 full minutes this time, reporting every 10 tries)'
$piar = 0
$threshold = 20
$limit = 300 
for($i=0; $i -le $limit; $i++){
    if( test-connection -ComputerName 192.168.1.1 -Quiet -Count 1 ) { 
        $piar++ 
        Start-Sleep -Seconds 1
        # without sleeping, a successful ping IMMEDIATELY starts enother ping
        # ...even if that means it's pinging 20x per second
    }
    else{ $piar = 0 }
    if(($i % 10) -eq 0){
        write-host '** ['$i'] '$piar' pings in-a-row, so far'
    }
    if($piar -gt $threshold){ 
        write-host "** It looks like it's back up now."
        break 
    }
}