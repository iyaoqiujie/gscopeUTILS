#!/bin/bash

YESTERDAY=`date -d "1 days ago" "+%Y-%m-%d"`

FTPROOT_DIR="/mediacenter/face/ftproot/"
RSYNCROOT_DIR="/mediacenter/face/rsyncROOT/"


find $FTPROOT_DIR -name $YESTERDAY -type d |xargs rm -rf
find $RSYNCROOT_DIR -name $YESTERDAY -type d |xargs rm -rf
