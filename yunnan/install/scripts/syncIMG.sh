#!/bin/bash

SRC=/mediacenter/face/rsyncROOT/

DST=/data2/
SFTP_URL=yqj@115.29.175.49:$DST

inotifywait -mrq --timefmt '%y-%m-%d %H:%M:%S' --format '%T%w%f' -e move,modify,create,delete $SRC | while read file 
do
    /usr/bin/rsync -avzR -e ssh $SRC/  $SFTP_URL
done
