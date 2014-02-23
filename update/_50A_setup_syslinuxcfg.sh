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

# setup BOOTDIR(probably /mnt/boot).
VMLINUZ_FULLPATH=`find ${COREDIR_BOOT}/ -name 'vmlinuz*'`
INITRD_FULLPATH=`find ${COREDIR_BOOT}/ -name 'initrd*'`
cp ${VMLINUZ_FULLPATH} ${BOOTDIR}/
cp ${INITRD_FULLPATH} ${BOOTDIR}/

CORE_VMLINUZ_FULLPATH=`find ${COREDIR_BOOT}/ -name 'vmlinuz*'| head -n1`
CORE_INITRD_FULLPATH=`find ${COREDIR_BOOT}/ -name 'initrd*'| head -n1`
CORE_VMLINUZ="${CORE_VMLINUZ_FULLPATH##${COREDIR_BOOT}/}"
CORE_INITRD="${CORE_INITRD_FULLPATH##${COREDIR_BOOT}/}"

SYSLINUX=${BOOTDIR}/syslinux.cfg
cat > ${SYSLINUX} <<EOFEOFEFO 
UI menu.c32
MENU TITLE Ubuntu Core Boot Menu

PROMPT 0
TIMEOUT 30
DEFAULT sub
LABEL core
	LINUX  ${CORE_VMLINUZ}
	APPEND root=${COREDEVICE} ro
	INITRD ${CORE_INITRD}
LABEL sub
	LINUX  ${CORE_VMLINUZ}
	APPEND root=${SUBDEVICE} ro
	INITRD ${CORE_INITRD}
EOFEOFEFO


# search vmlinux/initrd for preparation
for VMLINUZ_FILE in ${VMLINUZ_FULLPATH}; do 
    VMLINUZ="${VMLINUZ_FILE##${COREDIR_BOOT}/}"
    KERNVER+="${VMLINUZ##vmlinuz-} "
done

for i in ${KERNVER}; do 
cat >> ${SYSLINUX} <<EOFEOFEFO 
LABEL CORE-$i
	LINUX  vmlinuz-$i
	APPEND root=${COREDEVICE} ro
	INITRD initrd.img-$i
LABEL SUB-$i
	LINUX  vmlinuz-$i
	APPEND root=${SUBDEVICE} ro
	INITRD initrd.img-$i
EOFEOFEFO
done

ls -al  ${BOOTDIR}/syslinux.cfg 
sha1sum ${BOOTDIR}/syslinux.cfg 
cat     ${BOOTDIR}/syslinux.cfg 

cp /usr/lib/syslinux/menu.c32 ${BOOTDIR}/

syslinux -i ${BOOTDEVICE}

