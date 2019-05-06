
$cfe0 = 'C:\Users\jason\Documents\asus-rebadger\cfe1020.bin'
$cfe  = 'C:\Users\jason\Documents\asus-rebadger\original_cfe.bin'
$cfe2 = 'C:\Users\jason\Documents\asus-rebadger\new_cfe.bin'
$cfe3 = 'C:\Users\jason\Documents\asus-rebadger\undone_cfe.bin'

$macpatt = "(([0-9A-F]{2}\:){5}[0-9A-F]{2})"

# NOTE: index returned can be WRONG/offset if encoding is wrong
$keep1 = select-string -encoding default -path $cfe -pattern "et0macaddr=$macpatt"
$keep2 = select-string -encoding default -path $cfe -pattern "0\:macaddr=$macpatt"
$keep3 = select-string -encoding default -path $cfe -pattern "1\:macaddr=$macpatt"

# report the critical values
write-host -foregroundcolor yellow "keep1: index=$($keep1.Matches.Groups[1].Index) value=$($keep1.Matches.Groups[1].Value)"
write-host -foregroundcolor yellow "keep2: index=$($keep2.Matches.Groups[1].Index) value=$($keep2.Matches.Groups[1].Value)"
write-host -foregroundcolor yellow "keep3: index=$($keep3.Matches.Groups[1].Index) value=$($keep3.Matches.Groups[1].Value)"

# combine macs for later comparison
# and prep to do same for read-checks
$keepall = $keep1.Matches.Groups[1].Value + $keep2.Matches.Groups[1].Value + $keep3.Matches.Groups[1].Value
$checkall = ''

# open the CFE for read-checks
# read into 17-byte array
# (prob need to diff array for secret_code)
$bytes = New-Object -TypeName Byte[] -ArgumentList 17
$fs = [IO.File]::OpenRead($cfe) 


# read 17 bytes from the indices reported in each 'keep'
# and smash them together for later comparison
$bytes.clear()
$fs.seek($keep1.Matches.Groups[1].Index,'Begin') | out-null 
$fs.Read($bytes,0,17) | out-null 
$checkall += [System.Text.Encoding]::ASCII.GetString($bytes)

$bytes.clear()
$fs.seek($keep2.Matches.Groups[1].Index,'Begin') | out-null 
$fs.Read($bytes,0,17) | out-null 
$checkall += [System.Text.Encoding]::ASCII.GetString($bytes)

$bytes.clear()
$fs.seek($keep3.Matches.Groups[1].Index,'Begin') | out-null
$fs.Read($bytes,0,17) | out-null 
$checkall += [System.Text.Encoding]::ASCII.GetString($bytes)


# close the file and compare the original vs readcheck
$fs.close()
write-host "Survey saaays..."
if( $keepall -eq $checkall ){
    write-host -foregroundcolor green "indeed it matched"
}else{
    write-host -foregroundcolor red "fail!"
}
$keepall
$checkall



cp $cfe0 new_cfe.bin

$kill1 = select-string -encoding default -path $cfe0 -pattern "et0macaddr=$macpatt"
$kill2 = select-string -encoding default -path $cfe0 -pattern "0\:macaddr=$macpatt"
$kill3 = select-string -encoding default -path $cfe0 -pattern "1\:macaddr=$macpatt"

$fs = [IO.File]::OpenWrite($cfe2) 

$fs.seek($kill1.Matches.Groups[1].Index, 'Begin')
$fs.write( [system.text.encoding]::ASCII.GetBytes("AA:BB:CC:DD:EE:FF") ,0,17)
#$fs.write( [system.text.encoding]::ASCII.GetBytes($keep1.Matches.Groups[1].Value) ,0,17)
$fs.close()