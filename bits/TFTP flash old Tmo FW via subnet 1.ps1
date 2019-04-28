    write-host "Immediately executing TFTP transfer via subnet 1..."
    
    tftp -i 192.168.1.1 put TM-AC1900_3.0.0.4_376_1703-g0ffdbba.trx

    write-host "you should see something like xfer successful"
    pause