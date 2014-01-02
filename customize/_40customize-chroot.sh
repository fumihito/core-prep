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
echo COREDIR=${COREDIR:=/mnt/root} > ${DEBUGOUT}
echo ${HTTP_PROXY:=""}             > ${DEBUGOUT}
echo ${INSTALL_PACKAGES:="sudo"}   > ${DEBUGOUT}
echo ${QEMU_USER_STATIC:=""}       > ${DEBUGOUT}

if [ -z $HTTP_PROXY ]; then
    PROXY=""
else
    PROXY="HTTP_PROXY=${HTTP_PROXY}"
fi

# create environment
cp /etc/resolv.conf ${COREDIR}/etc/
# copy qemu-user-static for cross-arch.
if [ -n "${QEMU_USER_STATIC}" ] ; then
    "$QEMU_USER_STATIC_PATH"=`which "${QEMU_USER_STATIC}"`
    cp "${QEMU_USER_STATIC_PATH}" "${COREDIR}/${QEMU_USER_STATIC_PATH}"
fi

chroot ${COREDIR} mount -t proc proc /proc

chroot ${COREDIR} apt-get clean
chroot ${COREDIR} apt-get update

if [ -n "${INSTALL_PACKAGES}" ] ; then
     chroot ${COREDIR} ${PROXY} apt-get install -y ${INSTALL_PACKAGES}
fi

mkdir _installed_packages
cp ${COREDIR}/var/cache/apt/archives/*.deb _installed_packages/
chroot ${COREDIR} apt-get clean

# destroy environment
chroot ${COREDIR} umount -t proc proc /proc
if [ -n "${QEMU_USER_STATIC}" ] ; then
    rm "${COREDIR}/${QEMU_USER_STATIC_PATH}"
fi

rm ${COREDIR}/etc/resolv.conf

