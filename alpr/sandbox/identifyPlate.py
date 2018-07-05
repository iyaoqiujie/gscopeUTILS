#!/usr/bin/python
# -*- coding:utf-8 -*-

import sys,os
import getopt
import HyperLPRLite as pr
import cv2
import numpy as np
from PIL import Image, ImageDraw
import gevent
from gevent import socket
from gevent.queue import Queue, Empty
from gevent.server import DatagramServer
from gevent import monkey
monkey.patch_all()

tasks = Queue(maxsize=1024)

def drawRectBox(image,rect,addText):
    cv2.rectangle(image, (int(rect[0]), int(rect[1])), (int(rect[0] + rect[2]), int(rect[1] + rect[3])), (0,0, 255), 2,cv2.LINE_AA)
    cv2.rectangle(image, (int(rect[0]-1), int(rect[1])-16), (int(rect[0] + 115), int(rect[1])), (0, 0, 255), -1,
                  cv2.LINE_AA)
    img = Image.fromarray(image)
    draw = ImageDraw.Draw(img)
    draw.text((int(rect[0]+1), int(rect[1]-16)), addText.decode('utf-8'), (255, 255, 255), font=fontC)
    imagex = np.array(img)
    return imagex




model = pr.LPR('model/cascade.xml','model/model12.h5','model/ocr_plate_all_gru.h5')
def recognize(grr):
    for pstr,confidence,rect in model.SimpleRecognizePlateByE2E(grr):
        if confidence>0.7:
            print 'plate_str: [%s], plate_confidence: [%.2f]' %(pstr.encode('utf-8'), confidence)
        else:
            print 'unable to recognize the plate'


def usage():
    print 'Usage:'
    print 'identifyPlate.py [-h|--help]'
    print 'identifyPlate.py -i|--image <IMAGE FILE>'
    print

def main(argv):
    try:
        opts, args = getopt.getopt(argv, 'hi:', ['help', 'image'])
    except getopt.GetoptError:
        usage()
        sys.exit()

    if len(opts) == 0:
        usage()
        sys.exit()

    for opt, arg in opts:
        if opt in ('-h', '--help'):
            usage()
            sys.exit()
        elif opt in ('-i', '--image'):
            imgFile = arg
            grr = cv2.imread(imgFile)
            recognize(grr)

if __name__ == '__main__':
    main(sys.argv[1:])
