#!/bin/bash

## The root directory where the material lies in
ROOT_DIR=`PWD`


## Install & configure VPN client
function setupVPNClient()
{
	if [ ! -d $ROOT_DIR/vpn ]
	then
		echo "ERROR: NO vpn directory!"
		exit 1
	fi
	cd $ROOT_DIR/vpn

	apt-get update
	apt-get install -y pptp-linux

	cat chap-secrets >> /etc/ppp/chap-secrets
	cp gscope /etc/ppp/peers/
	cp ip-up-778route /etc/ppp/ip-up.d/778route
	chmod 777 /etc/ppp/ip-up.d/778route
	cd $ROOT_DIR
}

function setupFTPD()
{
	if [ ! -d /mediacenter ]
	then
		echo "ERROR: NO mediacenter directory!"
		exit 1
	fi

	## Replace apt source saucy with trusty
	cp /etc/apt/sources.list /etc/apt/sources.list_saucy
	sed -i 's/saucy/trusty/g' /etc/apt/sources.list

	apt-get update
	apt-get install -y pure-ftpd
	mkdir -p /mediacenter/face/ftproot
	chmod 777 /mediacenter/face/ftproot
	groupadd ftpuser
	useradd -g ftpuser -d /mediacenter/face/ftproot -s /bin/false ftpuser
	usermod -a -G inet ftpuser
	pure-pw useradd face -u ftpuser -d /mediacenter/face/ftproot
	pure-pw mkdb
	cd /etc/pure-ftpd/auth
	ln -s ../conf/PureDB 60puredb
	## Modify the bind port=8821
	echo "8821" > /etc/pure-ftpd/conf/Bind
}

function setupFaceDet()
{
}
