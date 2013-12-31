#!/bin/bash

DEVICE=$1
GO=$2

WHOAMI=`whoami`
if [ "x_${WHOAMI}" != "x_root" ] ; then
    echo "You must be root to do this operation."
    exit 1
fi
if [ -z $DEVICE ] ; then
    echo "You must specify target device."
    exit 2
fi
if [ "x_$GO" != "x_YESDOIT" ] ; then
    echo "** This Operation will erase your disk **"
    echo "So, you must exec with 'YESDOIT' keywords."
    exit 3
fi

for i in `cat /proc/swaps  | grep ${DEVICE} | cut -d' ' -f1 `; do 
    swapoff $i
done

parted -s ${DEVICE} mklabel msdos
parted -s ${DEVICE} mkpart primary 0% 2GB 
parted -s ${DEVICE} t 1 0C
parted -s ${DEVICE} set 1 boot on
parted -s ${DEVICE} mkpart primary 2GB 4GB
parted -s ${DEVICE} t 2 82
parted -s ${DEVICE} mkpart primary 4GB 12GB
parted -s ${DEVICE} t 3 83
parted -s ${DEVICE} mkpart primary 12GB 100%
parted -s ${DEVICE} t 4 83

mkfs.vfat -c -F 32 ${DEVICE}1
mkswap             ${DEVICE}2
mkfs.ext4          ${DEVICE}3
mkfs.ext4          ${DEVICE}4

parted -s ${DEVICE} p

