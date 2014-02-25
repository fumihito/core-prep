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

echo  ${PRE_SCRIPTS_DIR:="_customize_prescripts"}  > ${DEBUGOUT}
echo ${POST_SCRIPTS_DIR:="_customize_postscripts"} > ${DEBUGOUT}

if [ -z $HTTP_PROXY ]; then
    PROXY=""
else
    PROXY="HTTP_PROXY=${HTTP_PROXY}"
fi

### - create chrootenvironment ------------------------
cp /etc/resolv.conf ${COREDIR}/etc/
# copy qemu-user-static for cross-arch.
if [ -n "${QEMU_USER_STATIC}" ] ; then
    "$QEMU_USER_STATIC_PATH"=`which "${QEMU_USER_STATIC}"`
    cp "${QEMU_USER_STATIC_PATH}" "${COREDIR}/${QEMU_USER_STATIC_PATH}"
fi

# pre-mount
chroot ${COREDIR} mount -t proc proc /proc
chroot ${COREDIR} mount -t devpts devpts /dev/pts

### - start customize ------------------------

echo '=== Executing pre-scripts ==='
PRE_SCRIPTS_DEST=${COREDIR}/root/pre-scripts/
mkdir -p                 ${PRE_SCRIPTS_DEST}
cp -a ${PRE_SCRIPTS_DIR} ${PRE_SCRIPTS_DEST}/
chroot ${COREDIR} /bin/sh -c "find ${PRE_SCRIPTS_DEST}/${PRE_SCRIPTS_DIR} -name '*.sh' 2> /dev/null | xargs echo ###CRIT : Found ignored scripts in pre-scripts phase, run-parts does not support .sh filename!!"
chroot ${COREDIR} /bin/sh -c "ls -al              /root/pre-scripts/${PRE_SCRIPTS_DIR}"
chroot ${COREDIR} /bin/sh -c "run-parts --verbose /root/pre-scripts/${PRE_SCRIPTS_DIR} 2>&1"
rm -rf                   ${PRE_SCRIPTS_DEST}

echo '=== Executing apt related installations ==='
chroot ${COREDIR} apt-get clean
chroot ${COREDIR} apt-get update

# Faking up upstart commands, and install required packages.
# "fake" commands prevent from unwanted service starting.
# http://askubuntu.com/questions/74061/install-packages-without-starting-background-processes-and-services
FAKEPATH=/root/fake
INITFAKEPATH=${COREDIR}${FAKEPATH}
mkdir -p ${INITFAKEPATH}
    for i in service initctl invoke-rc.d restart start stop start-stop-daemon; do /bin/sh -c "ln -sf /bin/true ${INITFAKEPATH}/$i"
done;

if [ -n "${INSTALL_PACKAGES}" ] ; then
    export ${PROXY}
    chroot ${COREDIR} /bin/sh -c "${PROXY} PATH=${FAKEPATH}:\$PATH apt-get install -y ${INSTALL_PACKAGES}"
fi
rm -rf ${INITFAKEPATH}

echo '=== Executing post-scripts ==='
POST_SCRIPTS_DEST=${COREDIR}/root/post-scripts/
mkdir -p                  ${POST_SCRIPTS_DEST}
cp -a ${POST_SCRIPTS_DIR} ${POST_SCRIPTS_DEST}/
chroot ${COREDIR} /bin/sh -c "find ${POST_SCRIPTS_DEST}/${POST_SCRIPTS_DIR} -name '*.sh'| xargs echo ###CRIT : Found ignored scripts in post-scripts phase, run-parts does not support dot filename!!"
chroot ${COREDIR} /bin/sh -c "ls -al ${POST_SCRIPTS_DEST}/${POST_SCRIPTS_DIR}"
chroot ${COREDIR} /bin/sh -c "run-parts --verbose /root/post-scripts/${POST_SCRIPTS_DIR} 2>&1"
rm -rf                    ${POST_SCRIPTS_DEST}

mkdir _installed_packages
cp ${COREDIR}/var/cache/apt/archives/*.deb _installed_packages/
chroot ${COREDIR} apt-get clean

### - destroy chrootenvironment ------------------------
chroot ${COREDIR} umount /dev/pts
chroot ${COREDIR} umount /proc
if [ -n "${QEMU_USER_STATIC}" ] ; then
    rm "${COREDIR}/${QEMU_USER_STATIC_PATH}"
fi

rm ${COREDIR}/etc/resolv.conf

