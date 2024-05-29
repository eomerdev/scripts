#!/bin/sh

# Resize a video file keeping the aspect ratio
# Author: eomerdev <eomerdev@gmail.com>

INPUT=$1
OUTPUT=$2
WIDTH=$3
CRF=18
PRESET=slow

if [ $# -ne 3  ]
then
    echo "Usage: $0 <INPUT> <OUTPUT> <WIDTH>"
    exit 1
fi

if [ ! -f $INPUT ]
then
    echo "$INPUT file do not exists"
    exit 1
fi

if [ -f $OUTPUT ]
then
    echo "$OUTPUT file already exists"
    exit 1
fi

if ! [[ $WIDTH =~ ^[1-9][0-9]+$ ]]
then
    echo "Must enter a valid width"
    exit 1
fi

ffmpeg -i $INPUT -vf scale=-1:$WIDTH -preset $PRESET -crf $CRF $OUTPUT

exit 0
