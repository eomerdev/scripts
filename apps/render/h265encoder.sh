#!/bin/sh

# Encode H.265 video file
# Author: eomerdev <eomerdev@gmail.com>

INPUT=$1
OUTPUT=$2

# Default values
VCODEC=libx265
ACODEC=aac
CRF=28
ABITRATE=128k
PRESET=medium
VTAG=hvc1

function print_command() {
    echo "$0 <INPUT> <OUTPUT> [CRF]"
}

if [ $# -lt 2 ] || [ $# -gt 3 ]
then
    print_command
    exit 1
fi

if ! [ -e $INPUT ]
then
    echo "Input file $INPUT not found"
    exit 1
fi

if [ -e $OUTPUT ]
then
    echo "Output file $OUTPUT already exists"
    exit 1
fi

if [ $# -eq 3 ]
then
    CRF=$3
fi

ISNUMBER='^[0-9]+$'

if ! [[ $CRF =~  $ISNUMBER ]]
then
   echo "CRF invalid value. The valid CRF value range is 0-63."
   exit 1
fi

ffmpeg -i $INPUT -c:v $VCODEC -c:a $ACODEC -crf $CRF -b:a $ABITRATE -preset $PRESET -tag:v $VTAG $OUTPUT

exit 0
