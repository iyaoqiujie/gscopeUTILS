#!/bin/bash

## Clenan the image dir

YESTERDAY=`date -d "1 days ago" "+%Y-%m-%d"`
FTPROOT_DIR="/usr/local/ftproot/"
RSYNCROOT_DIR="/usr/local/rsyncROOT/"


find $FTPROOT_DIR -name $YESTERDAY -type d |xargs rm -rf
find $RSYNCROOT_DIR -name $YESTERDAY -type d |xargs rm -rf



## check the rsync process
RSYNC=`ps -ef|grep [s]yncIMG.sh`
if [ -z "$RSYNC" ]; then
	echo "rsync.sh is not brought up"
	 /usr/local/bin/syncIMG.sh  > /tmp/rsync.log 2>&1 &
else
	echo "rsync.sh is up"
fi



#
#
#ACAP_PROC=`ps -ef|grep [a]notherCapture.sh`
#if [ -z "$ACAP_PROC" ]; then
#	echo "anotherCapture.sh is not brought up"
#	 /usr/local/bin/anotherCapture.sh  > /tmp/acap.log 2>&1 &
#else
#	echo "anotherCapture.sh is up"
#fi


function reportVPN() {
	interface="br0"
	mac=`ifconfig $interface | grep HWaddr|awk '{print $5}'`
	clientIP=`ifconfig ppp4| grep "inet addr" | awk '{ print $2}' | awk -F: '{print $2}'`

	curl "http://gscopetech.com:8088/devices/reportClient?mac=$mac&clientIP=$clientIP"
}


## check VPN
VPN=`ifconfig|grep ppp4`

if [ -z "$VPN" ]; then
        echo "Start to connect to ppp4"
        pon gscope
        sleep 2
        VPN_PPP4=`ifconfig|grep ppp4`
        if [ -z "$VPN_PPP4" ]; then
                echo "ppp4 is NOT connected"
        else
                echo "ppp4 is successfully connected"
                route add -net 10.78.0.0 netmask 255.255.0.0 gw 10.78.0.1 dev ppp4
		reportVPN
        fi
else
        echo "ppp4 is already connected"        
	reportVPN
fi
