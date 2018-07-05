#!/usr/bin/env python
# -*- coding: utf-8 -*-
######################################################
## @Copyright Copyright(c) 2018
## @Company Hangzhou Pantuo Sci&Tech Inc.
## @Author  Qiujie Yao <yaoqiujie@gscopetech.com>
## @Date  2018-08-24
##
## Parse the configuration file
######################################################

import sys
import ConfigParser

cf = ConfigParser.ConfigParser()
#cf.read('/opt/sms/alpr_config.ini')
cf.read('/opt/CPR/alpr/alpr_config.ini')

try:
	root_dir = cf.get('COMMON', 'root_dir')
	log_file = cf.get('COMMON', 'log_file')

	ismg_host = cf.get('ISMG', 'host')
	ismg_port = cf.getint('ISMG', 'port')
	sp_id = cf.get('ISMG', 'sp_id')
	shared_secret = cf.get('ISMG', 'shared_secret')
	msg_from = cf.get('ISMG', 'msg_from') 
	keepalive_interval = cf.getint('ISMG', 'keepalive_interval')

except ConfigParser.NoSectionError, e:
	print e
	sys.exit(1)
except ConfigParser.NoOptionError, e:
	print e
	sys.exit(1)


if __name__ == '__main__':
	print root_dir, log_file
	print ismg_host, ismg_port
	print sp_id, shared_secret, msg_from
