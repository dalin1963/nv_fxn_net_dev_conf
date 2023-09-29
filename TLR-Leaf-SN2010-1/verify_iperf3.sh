#!/bin/bash

LOCATION=$1

HOSTNAME=`/bin/hostname -s`

# root@ubt-22-oob-mgt-server:~# ssh cumulus@RIR-Leaf-SN2010-50 "ip vrf exec default iperf3 -b 1024M -P 2 -c 172.24.240.240 -f g"
# :::::::::
# :::::::::
# - - - - - - - - - - - - - - - - - - - - - - - - -
# [ ID] Interval           Transfer     Bandwidth       Retr
# [  5]   0.00-10.00  sec   493 MBytes  0.41 Gbits/sec    0             sender
# [  5]   0.00-10.00  sec   493 MBytes  0.41 Gbits/sec                  receiver
# [  7]   0.00-10.00  sec   493 MBytes  0.41 Gbits/sec    0             sender
# [  7]   0.00-10.00  sec   493 MBytes  0.41 Gbits/sec                  receiver
# [SUM]   0.00-10.00  sec   986 MBytes  0.83 Gbits/sec    0             sender
# [SUM]   0.00-10.00  sec   986 MBytes  0.83 Gbits/sec                  receiver
# 
# iperf Done.
# 
# root@ubt-22-oob-mgt-server:~# ssh cumulus@RIR-Leaf-SN2010-50 "ip vrf exec default iperf3 -u -b 1024M -P 2 -c 172.24.240.240 -f g"
# :::::::::
# :::::::::
# - - - - - - - - - - - - - - - - - - - - - - - - -
# [ ID] Interval           Transfer     Bandwidth       Jitter    Lost/Total Datagrams
# [  5]   0.00-10.00  sec   377 MBytes  0.32 Gbits/sec  0.309 ms  0/48256 (0%)
# [  5] Sent 48256 datagrams
# [  7]   0.00-10.00  sec   377 MBytes  0.32 Gbits/sec  0.305 ms  0/48256 (0%)
# [  7] Sent 48256 datagrams
# [SUM]   0.00-10.00  sec   754 MBytes  0.63 Gbits/sec  0.307 ms  0/96512 (0%)
# 
# iperf Done.

case $HOSTNAME in
    *Leaf*|*Super*|*Spine*|*Storage*)
        HOSTNAME=`hostname`
        IPERF3_COMMAND="ip vrf exec default iperf3"
        ;;
    *SLB*)
        HOSTNAME=`/bin/hostname -s`
        IPERF3_COMMAND="/bin/iperf3"
        ;;
    *)
        ;;
esac

`echo $IPERF3_COMMAND` -P 2 -c 172.24.240.240 -f g > ierf3.log

echo "$LOCATION $HOSTNAME" | awk '{ printf( "%12s %22s   TCP ", $1, $2 ) }' && tail -4 ierf3.log | grep sender | cut -c 7-
echo "$LOCATION $HOSTNAME" | awk '{ printf( "%12s %22s   TCP ", $1, $2 ) }' && tail -4 ierf3.log | grep receiver | cut -c 7-

`echo $IPERF3_COMMAND` -u -P 2 -c 172.24.240.240 -f g > ierf3.log

echo "$LOCATION $HOSTNAME" | awk '{ printf( "%12s %22s   UDP ", $1, $2 ) }' && tail -4 ierf3.log | grep SUM | cut -c 7-
