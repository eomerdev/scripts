#!/bin/sh

# Extract a thumbnail from video file
# Author: eomerdev <eomerdev@gmail.com>

INPUT=$1
TIME=$2
OUTPUT=$3

function print_command() {
    echo "$0 <INPUT VIDEO> <TIME> <OUTPUT IMAGE>"
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

if [ -e $OUTPUT ]
then
    echo "Output file $OUTPUT already exists"
    exit 1
fi

ISTIME='^[0-9]{2}:[0-9]{2}:[0-9]{2}$'

if ! [[ $TIME =~ $ISTIME ]]
then
    echo "Time invalid. You must enter HOUR:MINUTE:SECOND to extract the frame."
    exit 1
fi

ffmpeg -ss $TIME -i $INPUT -frames:v 1 $OUTPUT

exit 0
