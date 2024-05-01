#!/bin/sh
#
# Check video file integrity
# Author: eomerdev <eomerdev@gmail.com>

TARGET=$1
LOGFILE=$2

if [ $# -ne 2 ]
then
    echo "Usage: $0 <TARGET> <LOGFILE>"
    exit 1
fi

if [ ! -f $TARGET ]
then
    echo "$TARGET is not a valid file"
    exit 1
fi

if [ -f $LOGFILE ]
then
    echo "$LOGFILE already exists"
    exit 1
fi

echo -n "Checking $TARGET integrity ... "

ffmpeg -v error -i $TARGET -f null - 2>$LOGFILE

echo "DONE"

echo "Results on $LOGFILE"

exit 0
