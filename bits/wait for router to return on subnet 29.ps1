write-host '** Waiting for the router to boot back up...'
$piar = 0
$threshold = 3
$limit = 40 #should be 40-ish because the TFTP window closes fast
for($i=0; $i -le $limit; $i++){
    if( test-connection -ComputerName 192.168.29.1 -Quiet -Delay 1 -Count 1 ) { 
        $piar++ 
    }
    else{ $piar = 0 }
    write-host "** [ $i ] $piar pings in-a-row, so far"

    if($piar -gt $threshold){ 
        write-host "** It looks like it's back up now."
        break 
    }
}