#!/bin/bash

set -u
echo =====================
echo $0
echo =====================

echo ${DEBUGOUT:=/dev/null} > /dev/null
echo COREROOT=${COREROOT:=/mnt/root}    > ${DEBUGOUT}
echo DEFAULTUSER=${DEFAULTUSER:=ubuntu} > ${DEBUGOUT}
echo DEFAULTPASS=${DEFAULTPASS:=ubuntu} > ${DEBUGOUT}

chroot ${COREROOT} useradd -d /home/${DEFAULTUSER} -m -s /bin/bash ${DEFAULTUSER}
chroot ${COREROOT} /bin/sh -c "echo ${DEFAULTUSER}:${DEFAULTPASS} | chpasswd"
chroot ${COREROOT} addgroup ${DEFAULTUSER} adm
chroot ${COREROOT} addgroup ${DEFAULTUSER} sudo
