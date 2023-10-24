#!/bin/sh

# Mount a LUKS device
# Author: eomerdev <eomerdev@gmail.com>

USER=`whoami`

if [ "$USER" != "root" ]
then
	echo "Error: You must be superuser"
	exit 1
fi

if [ $# -ne 2 ]
then
	echo "Usage: $0 <DEVICE> <MOUNT POINT>"
	exit 1
fi

DEVICE=$1
LUKS=${DEVICE:5:3}"_crypt"
DEVICE_LUKS="/dev/mapper/"$LUKS
MOUNT_POINT=$2

if ! [ -b $DEVICE ]
then
	echo "Error: Device $DEVICE not found"
	exit 1
fi

if ! [[ `blkid $DEVICE | grep crypto_LUKS` ]]
then
	echo "Error : $DEVICE is not a LUKS device"
	exit 1
fi

if [[ `blkid $DEVICE_LUKS` ]]
then
	echo "Error : Device LUKS $DEVICE is already open"
	exit 1
fi

if ! [ -d $MOUNT_POINT ]
then
	echo "Error: Directory $MOUNT_POINT not found"
	exit 1
fi

cryptsetup luksOpen $DEVICE $LUKS
mount $DEVICE_LUKS $MOUNT_POINT

exit 0
