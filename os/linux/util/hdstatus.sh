#!/bin/bash

# Generate a block device report
# Author: eomerdev <eomerdev@gmail.com>

if [ "$EUID" -ne 0 ]
then
    echo "You must be superuser"
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
    echo "$DEVICE isn't a block device"
    exit 1
fi

if [ ! `command -v smartctl` ]
then
    echo "SMART monitor tools isn't installed"
    exit 1
fi

DEVICE_NAME=$(smartctl -i $DEVICE | grep -i "Device Model" | sed 's/^.*://;s/^[  ]*//;s/[  ]*$//;s/[  ]/_/g')
DATE=$(date '+%Y-%m-%d')
DESC_NAME="$DEVICE_NAME"_"$DATE"
DST_FILE="hdstatus_$DESC_NAME".tar.gz

if [ -e $DST_FILE ]
then
    echo "File $DST_FILE already exists"
    exit 1
fi

DST_DIR=$(mktemp -d)

mkdir $DST_DIR/$DESC_NAME
smartctl -a $DEVICE > $DST_DIR/$DESC_NAME/smart.txt
fdisk -l $DEVICE > $DST_DIR/$DESC_NAME/fdisk.txt
tar -czf $DST_FILE -C $DST_DIR .

echo -e "\e[32mGenerated \e[33m$DEVICE \e[97mstatus file \e[31m$DST_FILE\e[0m"

exit 0
