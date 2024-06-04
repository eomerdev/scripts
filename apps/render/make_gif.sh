#!/bin/sh

# Make a GIF image from video file
# Author: eomerdev <eomerdev@gmail.com>

INPUT=$1
OUTPUT=$2
START=$3
DURATION=$4
FRAMES=10
WIDTH=360

if [ $# -ne 4 ]
then
    echo "Usage: $0 <INPUT> <OUTPUT> <START> <DURATION>"
    exit 1
fi

ffmpeg -i $INPUT -ss $START -t $DURATION -filter_complex "fps=$FRAMES, scale=-1:$WIDTH" $OUTPUT

exit 0
