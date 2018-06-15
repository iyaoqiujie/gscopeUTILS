#!/bin/bash


rtspURL1="rtsp://192.168.31.13:554/stream/av0_0"
OUTPUT_ROOT_DIR=/mediacenter/face/IMAGE-58696C71DF3D
FACE_DETECT_BIN=/mediacenter/face/install/bin/facedet_test
SFTP_URL=yqj@115.29.175.49:/data2/imageROOT/IMAGE-58696C71DF3D
CURR_DIR=`pwd`

while [ 1 ]
do
	$FACE_DETECT_BIN -i $rtspURL1 -o $OUTPUT_ROOT_DIR/cam1	

	cd $OUTPUT_ROOT_DIR
	/usr/bin/rsync -avzR -e ssh cam1 $SFTP_URL/	
	rm -f $OUTPUT_ROOT_DIR/cam1/*
	cd $CURR_DIR
	sleep 20
done
