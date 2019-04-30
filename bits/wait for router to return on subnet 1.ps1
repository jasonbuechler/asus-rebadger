write-host '** Waiting for the router to boot back up...'
write-host '**   (The Badger will wait up to 5 full minutes this time, reporting every 10 tries)'
$piar = 0
$threshold = 20
$limit = 300 
for($i=0; $i -le $limit; $i++){
    if( test-connection -ComputerName 192.168.1.1 -Quiet -delay 1 -Count 1 ) { 
        $piar++ 
    }
    else{ $piar = 0 }
	
    if(($i % 10) -eq 0){
		$rnd = $i - ($i%10)
        write-host "** [ $rnd ] $piar pings in-a-row, so far"
    }
    if($piar -gt $threshold){ 
        write-host "** It looks like it's back up now."
        break 
    }
}