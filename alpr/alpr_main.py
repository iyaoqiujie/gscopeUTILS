#!/usr/bin/env python
# -*- coding: utf-8 -*-
######################################################
## @Copyright Copyright(c) 2016
## @Company Hangzhou Pantuo Sci&Tech Inc.
## @Author  Qiujie Yao <yaoqiujie@gscopetech.com>
## @Date  2018-06-26
##
######################################################

import sys
reload(sys)
sys.setdefaultencoding('utf-8')
import HyperLPRLite as pr
import cv2
import numpy as np
from PIL import Image, ImageDraw
import re
import gevent
from gevent import socket
from gevent.server import DatagramServer
from gevent.pool import Pool
from gevent import monkey
monkey.patch_all()
from alpr_config import root_dir
from alpr_logger import alpr_logger


model = pr.LPR(root_dir+'model/cascade.xml', root_dir+'model/model12.h5', root_dir+'model/ocr_plate_all_gru.h5')
def recognize(imgFile):
    try:
        grr = cv2.imread(imgFile)
        for pstr,confidence,rect in model.SimpleRecognizePlateByE2E(grr):
            if confidence>0.8:
                alpr_logger.debug('plate_str: [%s], plate_confidence: [%.2f]' %(pstr.encode('utf-8'), confidence))
                return pstr
            else:
                alpr_logger.warning('Maybe wrong plate_str: [%s], plate_confidence: [%.2f]' %(pstr.encode('utf-8'), confidence))
                return ''
    except:
        alpr_logger.error('Invalid image file:[%s]' %(imgFile))
        return ''



class msg_manager(DatagramServer):
    def handle(self, data, address):
        alpr_logger.debug('RECV MSG [%s] from [%s]' %(data, address[0]))
        pstr = recognize(data.strip())
        if pstr == '':
            pstr = 'FAIL'
        self.socket.sendto(pstr, address)

if __name__ == '__main__':
	address = ('', 31200)
	sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
	sock.settimeout(60)
	sock.bind(address)
	boss = msg_manager(sock)

	gevent.joinall([gevent.spawn(boss.serve_forever)])
