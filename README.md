# Accounting for iptables

Minimalistic accounting for network throughput with iptable rules

Script matches on chains starting with "ACC_"
writes data series "timestamp,bits" to files of format "chain_name_ISO-date_source_destination

## Example Rules


    -N ACC_IN
    -N ACC_OUT
    -A INPUT -j ACC_IN
    -A OUTPUT -j ACC_OUT
    -A ACC_IN -s 8.8.4.4/32 -j RETURN
    -A ACC_IN -s 8.8.8.8/32 -j RETURN
    -A ACC_OUT -d 8.8.4.4/32 -j RETURN
    -A ACC_OUT -d 8.8.8.8/32 -j RETURN
    

## Thanks to

- http://blog.mague.com/?p=201
