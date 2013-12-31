#!/bin/bash

set -u
echo =====================
echo $0
echo =====================

WHOAMI=`whoami`
if [ "x_${WHOAMI}" != "x_root" ]; then
    echo "You must be root to do this operation."
    exit 1
fi

echo ${DEBUGOUT:=/dev/null} > /dev/null
echo COREDIR=${COREDIR:=/mnt/root}       > ${DEBUGOUT} 
echo COREDIR_BOOT=${COREDIR_BOOT:=${COREDIR}/boot} > ${DEBUGOUT}
echo BOOTDIR=${BOOTDIR:=/mnt/boot}       > ${DEBUGOUT}
echo BOOTDEVICE=${BOOTDEVICE:=/dev/sda1} > ${DEBUGOUT}
echo COREDEVICE=${COREDEVICE:=/dev/sda3} > ${DEBUGOUT}
echo SUBDEVICE=${SUBDEVICE:=/dev/sda4}   > ${DEBUGOUT}

# search vmlinux/initrd for preparation
VMLINUZ_FULLPATH=`find ${COREDIR_BOOT}/ -name 'vmlinuz*'`
VMLINUZ="${VMLINUZ_FULLPATH##${COREDIR_BOOT}/}"

INITRD_FULLPATH=`find ${COREDIR_BOOT}/ -name 'initrd*'`
INITRD="${INITRD_FULLPATH##${COREDIR_BOOT}/}"

# setup BOTODIR(probably /mnt/boot).
cp ${VMLINUZ_FULLPATH} ${BOOTDIR}/
cp ${INITRD_FULLPATH} ${BOOTDIR}/

cat > ${BOOTDIR}/syslinux.cfg <<EOFEOFEFO 
UI menu.c32
MENU TITLE Ubuntu Core Boot Menu

PROMPT 0
TIMEOUT 30
DEFAULT core

LABEL core
	LINUX  ${VMLINUZ}
	APPEND root=${COREDEVICE} ro
	INITRD ${INITRD}

LABEL sub
	LINUX  ${VMLINUZ}
	APPEND root=${SUBDEVICE} ro
	INITRD ${INITRD}
EOFEOFEFO

ls -al  ${BOOTDIR}/syslinux.cfg 
sha1sum ${BOOTDIR}/syslinux.cfg 

cp /usr/lib/syslinux/menu.c32 ${BOOTDIR}/

syslinux -i ${BOOTDEVICE}

