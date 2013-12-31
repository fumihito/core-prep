#!/bin/bash

set -u
echo =====================
echo $0
echo =====================

echo ${DEBUGOUT:=/dev/null} > /dev/null
echo COREDIR=${COREDIR:=/mnt/root} > ${DEBUGOUT}
echo BOOTDIR=${BOOTDIR:=/mnt/boot} > ${DEBUGOUT}
echo BOOTDEVICE=${BOOTDEVICE:=/dev/sda1} > ${DEBUGOUT}
echo COREDEVICE=${COREDEVICE:=/dev/sda3} > ${DEBUGOUT}

WHOAMI=`whoami`
if [ "x_${WHOAMI}" != "x_root" ]; then
    echo "You must be root to do this operation."
    exit 1
fi

if [ ! -d "$BOOTDIR" ]; then mkdir  "$BOOTDIR"; fi
umount "$BOOTDIR"
mount  -v "$BOOTDEVICE" "$BOOTDIR" || exit 1

if [ ! -d "$COREDIR" ]; then mkdir  "$COREDIR"; fi
umount "$COREDIR"
mount  -v "$COREDEVICE" "$COREDIR" || exit 2
