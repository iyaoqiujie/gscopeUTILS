#!/bin/bash
export LD_LIBRARY_PATH=/usr/local/lib


TODAY=`date "+%Y-%m-%d"`
SRC_DIR="/mediacenter/face/ftproot/$TODAY/IPC1174677545/1/"
DST_DIR="/mediacenter/face/rsyncROOT/IPC1174677545/$TODAY/"
SIMILAR="/usr/local/bin/similar"

if [ ! -d $DST_DIR ]
then
    mkdir -p $DST_DIR
fi

IMAGES=(`ls  $SRC_DIR/*.jpg 2>/dev/null`)
len=${#IMAGES[*]}
if [ $len -lt 2 ] 
then
	echo "No need to compare"
	exit 0
fi

srcImage=${IMAGES[0]}
for((i=1;i<$len;i=$i+1))
do
	targetImage=${IMAGES[$i]}
	$SIMILAR -s $srcImage -t $targetImage -v 0.8
	ret=$?
	if [ $ret = '11' ] 
	then
		echo "$srcImage was broken, so it will be deleted"
		rm -f $srcImage
		srcImage=$targetImage
	elif [ $ret = '12' ]
	then
		echo "$targetImage was broken, so it will be deleted"
		rm -f $targetImage
	elif [ $ret = '99' ] 
	then
		echo "$targetImage is nearly the same as $srcImage, so it will be deleted"
		rm -f $targetImage
	elif [ $ret = '17' ] 
	then
		echo "$targetImage is different from $srcImage"
		mv $srcImage $DST_DIR/
		#cp $srcImage $DST_DIR/
		srcImage=$targetImage
	fi
done
