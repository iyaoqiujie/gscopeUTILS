#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys, socket
address = ('127.0.0.1', 31200)
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

sock.connect(address)
while True:
	print "Enter data to transmit:"
	data = sys.stdin.readline().strip()
	sock.sendall(data)
	print "Looking for replies; press Ctrl-C or Ctrl-Break to stop."
	buf = sock.recv(2048)
	if not len(buf):
		break;
	print "Server replies: %s" %(buf)
