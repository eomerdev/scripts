#!/bin/sh

# Start webcam device on 720p 30fps

WIDTH=1280
HEIGHT=720
FPS=30
PLAYER=mplayer

if [ $# -ne 1 ]
then
    echo "Usage $0 <DEVICE>"
    exit 1
fi

DEVICE=$1

if ! [ -c $DEVICE ]
then
    echo "$DEVICE not found"
    exit 1
fi

if ! [[ $(command -v $PLAYER) ]]
then
    echo "$PLAYER not found"
    exit 1
fi

$PLAYER tv:// -tv driver=v4l2:device=$DEVICE:width=$WIDTH:height=$HEIGHT:fps=$FPS:outfmt=yuy2

exit 0
