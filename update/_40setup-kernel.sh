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
echo MASTER=${MASTER:=172.20.200.20}                   > ${DEBUGOUT}
echo KERNELNAME=${KERNELNAME:=kernel_i386_current.tar} > ${DEBUGOUT}
echo KERNELDOWNLOADURL=${KERNELDOWNLOADURL:=http://${MASTER}/ubuntu-core/${KERNELNAME}} > ${DEBUGOUT}
echo COREROOT=${COREROOT:=/mnt/root}                   > ${DEBUGOUT}

if [ -f ${KERNELNAME} ] ;then
    echo "${KERNELNAME} already exists"
else
    wget ${KERNELDOWNLOADURL} -O ${KERNELNAME} -o /dev/null
fi

CHROOTTEMPDIR=`mktemp -d ${COREROOT}/tmp/kernelextract_XXXXX`
tar axf ${KERNELNAME} -C ${CHROOTTEMPDIR}
chroot ${COREROOT} /bin/bash -c "cd ${CHROOTTEMPDIR##${COREROOT}} && mount -t proc proc /proc && dpkg -i *.deb ; umount /proc"

rm -rf ${CHROOTTEMPDIR} 
