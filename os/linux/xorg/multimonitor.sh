#!/bin/sh

# Toggle single/multi monitor mode for two monitors.
# Author: eomerdev <eomerdev@gmail.com>

PRIM_OUTPUT=`xrandr | awk '/ primary / {print $1}'`
ACTIVE=`xrandr --listactivemonitors | grep Monitors | cut -d : -f2`

if [ $# -eq 0 ]
then
    echo "$0 <SECONDARY OUTPUT>"
    exit 1
fi

SEC_OUTPUT=$1

if [ -z "`xrandr | grep $SEC_OUTPUT`" ] || [ "$SEC_OUTPUT" == "$PRIM_OUTPUT" ]
then
    echo "Invalid output $SEC_OUTPUT"
    exit 1
fi

if [ "$ACTIVE" -eq 1 ]
then
    xrandr --output $PRIM_OUTPUT --primary --auto --output $SEC_OUTPUT --auto --above $PRIM_OUTPUT
    echo "To Multi monitor mode"
elif [ "$ACTIVE" -eq 2 ]
then
    xrandr --output $PRIM_OUTPUT --primary --auto --output $SEC_OUTPUT --off
    echo "To Single monitor mode"
fi

exit 0
