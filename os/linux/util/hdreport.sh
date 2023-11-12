#!/bin/sh

# Generate a report of block device.

USER=`whoami`

if [ "$USER" != "root" ]
then
    echo "Error: You must be superuser"
    exit 1
fi

if [ $# -ne 2 ]
then
    echo "Usage: $0 <DEVICE> <OUTPUT DIRECTORY>"
    exit 1
fi

DEVICE=$1
OUTPUT=$2

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

if [ ! -d $OUTPUT ]
then
    echo "Error: Directory $DIRECTORY not found"
    exit 1
fi

DEVICE_NAME=`echo $DEVICE | awk -F"/" '{print $NF}'`
NOW=`date +%m-%d-%y`
SIZE=`df -h | grep $MOUNT_POINT | awk '{ print $2 }'`
USED=`df -h | grep $MOUNT_POINT | awk '{ print $3 }'`
FREE=`df -h | grep $MOUNT_POINT | awk '{ print $4 }'`
PERCENT=`df -h | grep $MOUNT_POINT | awk '{ print $5 }'`
FILES=`sudo ls -R $MOUNT_POINT | wc -l`
DEST_FILE=$OUTPUT/$DEVICE_NAME.content.$NOW.txt

echo -e "\e[97mDevice Report\e[0m"
echo -e "\e[97mDevice: \e[96m$DEVICE\e[0m"
echo -e "\e[97mSize: \e[96m$SIZE\e[0m"
echo -e "\e[97mUsed Space: \e[96m$USED\e[0m"
echo -e "\e[97mFree Space: \e[96m$FREE ($PERCENT)\e[0m"
echo -e "\e[97mFiles: \e[96m$FILES\e[0m"
echo -e "\e[97mDate: \e[96m$NOW\e[0m"

echo "Device Report of $DEVICE on $NOW" &> $DEST_FILE
echo "Size: $SIZE" &>> $DEST_FILE
echo "Used: $USED" &>> $DEST_FILE
echo "Free: $FREE" &>> $DEST_FILE
echo "Files: $FILES" &>> $DEST_FILE
echo "Content:" &>> $DEST_FILE
ls -lRa $MOUNT_POINT &>> $DEST_FILE
echo
echo -e "\e[97mDevice Report \e[33m$DEST_FILE \e[32msuccessfully generated\e[0m"

exit 0
