#!/bin/sh

# Generate a report of block device.

USER=`whoami`

if [ "$USER" != "root" ]
then
    echo "Error: You must be superuser"
    exit 1
fi

if [ $# -ne 1 ]
then
    echo "Usage: $0 <DEVICE>"
    exit 1
fi

DEVICE=$1

if [ ! -b $DEVICE ]
then
    echo "Error: Device $1 not found"
    exit 1
fi

MOUNT_POINT=`findmnt -n $DEVICE | awk '{ print $1 }'`

if [ ! $MOUNT_POINT ]
then
    echo "Error: Device $DEVICE not mounted"
    exit 1
fi

NOW=`date +%m-%d-%y`
SIZE=`df -h | grep $MOUNT_POINT | awk '{ print $2 }'`
USED=`df -h | grep $MOUNT_POINT | awk '{ print $3 }'`
FREE=`df -h | grep $MOUNT_POINT | awk '{ print $4 }'`
PERCENT=`df -h | grep $MOUNT_POINT | awk '{ print $5 }'`
FILES=`sudo ls -R $MOUNT_POINT | wc -l`

echo "Device: $DEVICE"
echo "Size: $SIZE"
echo "Used Space: $USED"
echo "Free Space: $FREE ($PERCENT)"
echo "Files: $FILES"
echo "Date: $NOW"
ls -lRa $MOUNT_POINT

exit 0
