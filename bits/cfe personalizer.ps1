

$cfe     = 'original_cfe.bin'
$cfe_new = 'new_cfe.bin'
$cfe_bak = 'new_cfe.bin.bak'
$cfe_unp = 'unpatched_new_cfe.bin'

$macpatt = "(([0-9A-FX]{2}\:){5}[0-9A-FX]{2})" # note the X in there for "XX:XX:XX..." prepped cfe's
$wpspatt = "([0-9X]{8})"

# NOTE: Yes, I'm fully aware this code could be made (a lot) cleaner by
#  using some list/array to store this stuff, and later iterate through
#  in a simple loop... but I want this to be as readable as possible
#  by people without much coding experience.

# first we find the required patterns in original_cfe.bin
# (we're most interested in the returned string values)
$keep1 = select-string -encoding default -path $cfe -pattern "et0macaddr=$macpatt"
$keep2 = select-string -encoding default -path $cfe -pattern "0\:macaddr=$macpatt"
$keep3 = select-string -encoding default -path $cfe -pattern "1\:macaddr=$macpatt"
$keep4 = select-string -encoding default -path $cfe -pattern "secret_code=$wpspatt"

# then we find the same patterns in new_cfe.bin
# (we're most interested in the returned byte-locations)
$kill1 = select-string -encoding default -path $cfe_new -pattern "et0macaddr=$macpatt"
$kill2 = select-string -encoding default -path $cfe_new -pattern "0\:macaddr=$macpatt"
$kill3 = select-string -encoding default -path $cfe_new -pattern "1\:macaddr=$macpatt"
$kill4 = select-string -encoding default -path $cfe_new -pattern "secret_code=$wpspatt"

# to keep the code readable, we're explicitly labeling everything
$keep1_addr = $keep1.Matches.Groups[1].Index # 1st mac in the cfe's first-byte location
$keep2_addr = $keep2.Matches.Groups[1].Index
$keep3_addr = $keep3.Matches.Groups[1].Index
$keep4_addr = $keep4.Matches.Groups[1].Index
$keep1_val  = $keep1.Matches.Groups[1].Value # 1st mac in the cfe's string values
$keep2_val  = $keep2.Matches.Groups[1].Value
$keep3_val  = $keep3.Matches.Groups[1].Value
$keep4_val  = $keep4.Matches.Groups[1].Value
$keep1_valB = [system.text.encoding]::ASCII.GetBytes($keep1_val) # byte values of the 1st mac in the cfe
$keep2_valB = [system.text.encoding]::ASCII.GetBytes($keep2_val) # Needed both for sanity-check reads, and
$keep3_valB = [system.text.encoding]::ASCII.GetBytes($keep3_val) # for overwriting bytes of target cfe
$keep4_valB = [system.text.encoding]::ASCII.GetBytes($keep4_val) # 
$kill1_addr = $kill1.Matches.Groups[1].Index
$kill2_addr = $kill2.Matches.Groups[1].Index
$kill3_addr = $kill3.Matches.Groups[1].Index
$kill4_addr = $kill4.Matches.Groups[1].Index
$kill1_val  = $kill1.Matches.Groups[1].Value
$kill2_val  = $kill2.Matches.Groups[1].Value
$kill3_val  = $kill3.Matches.Groups[1].Value
$kill4_val  = $kill4.Matches.Groups[1].Value
$kill1_valB = [system.text.encoding]::ASCII.GetBytes($kill1_val)
$kill2_valB = [system.text.encoding]::ASCII.GetBytes($kill2_val)
$kill3_valB = [system.text.encoding]::ASCII.GetBytes($kill3_val)
$kill4_valB = [system.text.encoding]::ASCII.GetBytes($kill4_val)

# purely informational printing
# ex:   38:2C:4A:EF:3E:88 [1233 / 0x4d1] <-- et0macaddr=38:2C:4A:EF:3E:88
#       |                  |                 |
#   mac pattern            |                 |
#              byte-0 decimal/hex address    |
#                                    full matched pattern
$reporting = @"
original_cfe.bin
* $keep1_val [$keep1_addr / $([String]::Format("0x{0:x3}", $keep1_addr))] <-- $($keep1.matches.value)
* $keep2_val [$keep2_addr / $([String]::Format("0x{0:x3}", $keep2_addr))] <-- $($keep2.matches.value)
* $keep3_val [$keep3_addr / $([String]::Format("0x{0:x3}", $keep3_addr))] <-- $($keep3.matches.value)
* $keep4_val [$keep4_addr / $([String]::Format("0x{0:x3}", $keep4_addr))] <-- $($keep4.matches.value)

new_cfe.bin (before patching)
* $kill1_val [$kill1_addr / $([String]::Format("0x{0:x3}", $kill1_addr))] <-- $($kill1.matches.value)
* $kill2_val [$kill2_addr / $([String]::Format("0x{0:x3}", $kill2_addr))] <-- $($kill2.matches.value)
* $kill3_val [$kill3_addr / $([String]::Format("0x{0:x3}", $kill3_addr))] <-- $($kill3.matches.value)
* $kill4_val [$kill4_addr / $([String]::Format("0x{0:x3}", $kill4_addr))] <-- $($kill4.matches.value)

"@
write-host $reporting -foregroundColor yellow
pause
write-host ''


# open the CFE for read-checks
# read into 17-byte array
# (prob need to diff array for secret_code)
$bytes = New-Object -TypeName Byte[] -ArgumentList 17

$bytes.clear()								# zeroes all 17 elements of $bytes (unnecessary but nice)
$fs = [IO.File]::OpenRead($cfe) 			# open original_cfe.bin as filestream "$fs" (for reading)
$fs.Seek($keep3_addr,'Begin') | out-null	# set the "current" address to presumed address of keep3_val
$fs.Read($bytes,0,17) | out-null 			# read 17 bytes from cfe into the 17-byte buffer, "$bytes"
$fs.close()

$bytes_as_string = [System.Text.Encoding]::ASCII.GetString($bytes)
if( $bytes_as_string -eq $keep3_val ){
    write-host -foregroundcolor green "1st read-address sanity check passed :)"
}else{
    write-host -foregroundcolor red "fail!"
    pause
}


#
# now we repeat the process to check address validity in the other (new) cfe filestream
# (since it's a different origin, who knows, maybe it has different encoding)
#

$bytes.clear()								# zeroes all 17 elements of $bytes (good idea now)
$fs = [IO.File]::OpenRead($cfe_new) 		# open new_cfe.bin as filestream "$fs" (for reading)
$fs.Seek($kill3_addr,'Begin') | out-null	# set the "current" address to presumed address of kill3_val
$fs.Read($bytes,0,17) | out-null 			# read 17 bytes from cfe into the 17-byte buffer, "$bytes"
$fs.close()

$bytes_as_string = [System.Text.Encoding]::ASCII.GetString($bytes)
if( $bytes_as_string -eq $kill3_val ){
    write-host -foregroundcolor green "2nd read-address sanity check passed :)"
}else{
    write-host -foregroundcolor red "fail!"
    pause
}

write-host ''
write-host "** (Backing up $cfe to $cfe_bak.)"
write-host "** Now using critical vals from original_cfe.bin to overwrite those in new_cfe.bin"
cp $cfe_new $cfe_bak
$fs = [IO.File]::OpenWrite($cfe_new) 
$fs.seek($kill1_addr, 'Begin') | out-null
$fs.write($keep1_valB, 0, 17) | out-null
$fs.seek($kill2_addr, 'Begin') | out-null
$fs.write($keep2_valB, 0, 17) | out-null
$fs.seek($kill3_addr, 'Begin') | out-null
$fs.write($keep3_valB, 0, 17) | out-null
$fs.seek($kill4_addr, 'Begin') | out-null
$fs.write($keep4_valB, 0, 8) | out-null
$fs.close()


$check1 = select-string -encoding default -path $cfe_new -pattern "et0macaddr=$macpatt"
$check2 = select-string -encoding default -path $cfe_new -pattern "0\:macaddr=$macpatt"
$check3 = select-string -encoding default -path $cfe_new -pattern "1\:macaddr=$macpatt"
$check4 = select-string -encoding default -path $cfe_new -pattern "secret_code=$wpspatt"

$keep1.Matches.value -eq $check1.Matches.value
$keep2.Matches.value -eq $check2.Matches.value
$keep3.Matches.value -eq $check3.Matches.value
$keep4.Matches.value -eq $check4.Matches.value

pause


#
# Convert string to byte array:
#  [system.text.encoding]::ASCII.GetBytes("AA:BB:CC:DD:EE:FF")
#
# Convert byte array to string:
#  [System.Text.Encoding]::ASCII.GetString($bytes)
#

$old = @"

#
# now we prep for the last sanity check:
# if we can write to the same addresses with the bytes that were 
# originally there, we should produce a file identical to the 
# starting file, and prove addressing is accurate
#    new_cfe.bin.bak == unpatched_new_cfe.bin
#
write-host "** (Cloning $cfe_new to $cfe_unp to prep for sanity check.)"
write-host "** Now using critical vals from (pre-mod) $cfe_new to overwrite those in $cfe_unp"
cp $cfe_new $cfe_unp
$fs = [IO.File]::OpenWrite($cfe_unp) 
$fs.seek($kill1_addr, 'Begin') | out-null
$fs.write($kill1_valB, 0, 17) | out-null
$fs.seek($kill2_addr, 'Begin') | out-null
$fs.write($kill2_valB, 0, 17) | out-null
$fs.seek($kill3_addr, 'Begin') | out-null
$fs.write($kill3_valB, 0, 17) | out-null
$fs.close()

write-host "** $cfe_unp should now be identical to $cfe_bak"
write-host "** (demonstrating modification addresses were accurate)"

"@