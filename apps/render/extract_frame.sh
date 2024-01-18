#!/bin/sh

# Extract frame from video file at certein timestamp
# Author: eomerdev <eomerdev@gmail.com>

INPUT=$1
TIMESTAMP=$2
OUTPUT=$3

if [ $# -ne 3 ]
then
    echo "$0 <INPUT> <TIMESTAMP> <OUTPUT>"
    exit 1
fi

if ! [ -e $INPUT ]
then
    echo "Input file $INPUT not found"
    exit 1
fi

ISTIMESTAMP='^[0-9]{2}:[0-9]{2}:[0-9]{2}$'

if ! [[ $TIMESTAMP =~ $ISTIMESTAMP ]]
then
    echo "Timestamp invalid value. For example: 01:02:03."
    exit 1
fi

ffmpeg -hide_banner -loglevel quiet -ss $TIMESTAMP -i $INPUT -frames:v 1 $OUTPUT

exit 0
