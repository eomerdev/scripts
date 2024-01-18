#!/bin/sh

# Adds a thumbnail to video file
# Author: eomerdev <eomerdev@gmail.com>

INPUT=$1
THUMBNAIL=$2
OUTPUT=$3

function print_command() {
    echo "$0 <INPUT VIDEO> <THUMBNAIL> <OUTPUT VIDEO>"
}

if [ $# -ne 3 ]
then
    print_command
    exit 1
fi

if ! [ -e $INPUT ]
then
    echo "Input file $INPUT not found"
    exit 1
fi

if ! [ -e $THUMBNAIL ]
then
    echo "Thumbnail file $THUMBNAIL not found"
    exit 1
fi

if [ -e $OUTPUT ]
then
    echo "Output file $OUTPUT already exists"
    exit 1
fi

ffmpeg -i $INPUT -i $THUMBNAIL -map 1 -map 0 -c copy -disposition:0 attached_pic $OUTPUT

exit 0
