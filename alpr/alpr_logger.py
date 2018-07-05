#!/usr/bin/env python
# -*- coding: utf-8 -*-
######################################################
## @Copyright Copyright(c) 2018
## @Company Hangzhou Pantuo Sci&Tech Inc.
## @Author  Qiujie Yao <yaoqiujie@gscopetech.com>
## @Date  2018-06-24
##
## The logger system
######################################################

import logging
import logging.handlers

from alpr_config import log_file

## Create loggers
alpr_logger = logging.getLogger('ALPR')
alpr_logger.setLevel(logging.DEBUG)


## File Handlers
alpr_log_handler = logging.handlers.RotatingFileHandler(log_file, maxBytes=50*1024*1024, backupCount=30)
alpr_log_handler.setLevel(logging.DEBUG)

## Console Handler
#console_handler = logging.StreamHandler()
#console_handler.setLevel(logging.ERROR)

## Create formatters and add it to the handlers
LOG_FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(filename)s:%(lineno)d <%(process)d %(thread)d> --- %(message)s'
alpr_log_handler.setFormatter(logging.Formatter(LOG_FORMAT))
#console_handler.setFormatter(formatter)

## Add the handlers to the loggers
alpr_logger.addHandler(alpr_log_handler)

if __name__ == '__main__':
	alpr_logger.debug("Hello world")
	alpr_logger.info("Hello world")
	alpr_logger.warning("Hello world")
	alpr_logger.error("Hello world")
	alpr_logger.critical("Hello world")
