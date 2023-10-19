#!/bin/sh

# Set resolution of the primary output for the monitor
# Author: eomerdev <eomerdev@gmail.com>

PRIM_OUTPUT=`xrandr | awk '/ primary / {print $1}'`

if [ $# -eq 0 ]
then
    xrandr --output $PRIM_OUTPUT --auto
elif [ $# -eq 2 ]
then
    xrandr --output $PRIM_OUTPUT --mode $1 --rate $2
else
    echo "Usage: $0 [<RESOLUTION> <RATE>]"
    exit 1
fi

exit 0
