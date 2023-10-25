#!/bin/sh

# Unmount a LUKS device
# Author: eomerdev <eomerdev@gmail.com>

USER=`whoami`

if [ "$USER" != "root" ]
then
	echo "Error: You must be superuser"
	exit 1
fi

if [ $# -ne 1 ]
then
	echo "Usage: $0 <MOUNT POINT>"
	exit 1
fi

MOUNT_POINT=$1

if ! [[ `mount | grep $MOUNT_POINT` ]]
then
	echo "Error : Directory $MOUNT_POINT not mounted"
	exit 1
fi

DEVICE_LUKS=`mount | grep $MOUNT_POINT | awk '{ print $1 }'` 
LUKS=${DEVICE_LUKS:12}

if ! [[ "$DEVICE_LUKS" =~ crypt$ ]]
then
	echo "Error: $DEVICE_LUKS is not a LUKS device"
	exit 1
fi

umount $MOUNT_POINT
cryptsetup luksClose $LUKS

exit 0
