#!/bin/bash

CONFIG_FILE=/usr/local/etc/agent.conf

## AP MAC
interface="ppp0"
apmac=`ifconfig $interface | grep HWaddr|awk '{print $5}'`
if [ "x$apmac" = "x" ]
then
	echo "ERROR: bad interface: $interface"
	exit 1
fi

## Agent Version
apver="0.0"
if [ -f $CONFIG_FILE ]
then
	agentVer=`sed -n '/AgentVer/p' $CONFIG_FILE`
	apver=${agentVer#*=}
fi

httpResponse=`curl -s "http://gscopetech.com:8088/devices/heartbeat?apmac=$apmac&currVer=$apver"`
isOK=`echo $httpResponse|grep "result=OK"`
if [ $isOK = "0" ]
then
	echo "ERROR: bad response"
	exit 1
fi

targetVer=`echo $httpResponse|awk -F'&' '{print $2}'|cut -d'=' -f2`
if [ "x$apver" = "x$targetVer" -o "x$targetVer" = "x0.0" ]
then
	echo "INFO: already have the latest agent"
	exit 0
fi

## Start to upgrade
## Fetch the bundle first

## Check if the install.sh exists or not
INSTALL_EXISTS=`ps -ef|grep [i]nstall.sh|grep -v grep`
if [ ! -z $INSTALL_EXISTS ]
then
	echo "WARNING: the installation of the agent has already begun"
	exit 0
fi

TMP_DIR=/mediacenter/face/tmp
if [ ! -d /mediacenter ]
then
	echo "ERROR: no /mediacenter directory! Unable to setup agent"
	exit 1
fi
mkdir -p $TMP_DIR
rm -rf $TMP_DIR/bundle*

## wget [选项]... [URL]...
## 选项:
## -o,  --output-file=FILE        将日志信息写入 FILE。
## -t,  --tries=NUMBER            设置重试次数为 NUMBER (0 代表无限制)。
## -O,  --output-document=FILE    将文档写入 FILE。
## -c,  --continue                断点续传下载文件。
## -w,  --wait=SECONDS            等待间隔为 SECONDS 秒。
wget -t 5 -o /tmp/download.log -O $TMP_DIR/bundle.tar.gz -c -w 15  "http://gscopetech.com:8088/media/uploads/swupgrade/$targetVer/bundle.tar.gz"
if [ $? != 0 ]
then
	echo "ERROR: failed to download /media/uploads/swupgrade/$targetVer/bundle.tar.gz"
	exit 1
fi

## untar the bundle

tar xvzf $TMP_DIR/bundle.tar.gz -C $TMP_DIR >/dev/null 2>&1
if [ $? != 0 ]
then
	echo "ERROR: failed to untar the bundle.tar.gz"
	exit 1
fi

cd $TMP_DIR/bundle
nohup ./install.sh >> /tmp/agentInst.log 2>&1 &
echo "INFO: start to install"
exit 0
