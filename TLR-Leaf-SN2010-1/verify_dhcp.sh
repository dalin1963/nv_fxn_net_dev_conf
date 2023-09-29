#!/bin/bash

LOCATION=$1

for IP in `awk -F\( '{ print $2 }' ~/leaf_IP_MAC.log | awk -F\) '{ print $1 }'`
do
    MAC=`grep $IP ~/leaf_IP_MAC.log | awk '{ print $4 }'`
    HOST=`grep $IP /etc/hosts | awk '{ print $2 }'`

    echo -n "$LOCATION $HOST "

    ping -q -c 1 $HOST > /dev/null 2>&1
    typeset -i PING_STATUS=$?

    if [[ $PING_STATUS -eq 0 ]]; then
        ssh cumulus@$HOST "net show bridge macs" | grep -q $MAC
        typeset -i STATUS=$?

        if [[ $STATUS -eq 0 ]]; then
            typeset -i COUNT=`ssh cumulus@$HOST "net show bridge macs" | grep swp4 | wc -l`

	    if [[ $COUNT -eq 1 ]]; then
                ssh cumulus@$HOST "net show bridge macs" | grep swp4 | cut -c 23-
            else
                ssh cumulus@$HOST "net show bridge macs" | grep swp4 | grep -v 90:0a | cut -c 23-
            fi
        else
            "Leaf has NO MATCHED swp4 connected to Spine!"
        fi
    fi

    echo ""
done
