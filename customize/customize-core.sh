#!/bin/bash

export COREDIR=/mnt/root
export BOOTDIR=/mnt/boot

export MASTER=172.20.200.20
export TARBALLNAME=ubuntu-core-12.04.3-core-i386_current.tar.gz
export COREDOWNLOADURL=http://${MASTER}/ubuntu-core/${TARBALLNAME}
export HTTP_PROXY
## if you use arm-cross Ubuntu core, please uncomment.
# export QEMU_USER_STATIC=qemu-arm-static

export INSTALL_PACKAGES="less sudo isc-dhcp-client wget bash-completion net-tools iputils-ping"

FILE=$1

#------------------------------------

WHOAMI=`whoami`
if [ "x_${WHOAMI}" != "x_root" ]; then
    echo "You must be root to do this operation."
    exit 1
fi


bash _10mount-fs.sh

echo FILE=${FILE:=`bash _20get-tar.sh`}

if [ -n "$FILE" ]; then
    bash _30extract-core.sh $FILE
else 
    echo "_20get-tar.sh failed, script return non-file results."
    exit 1
fi

bash _40customize-chroot.sh
bash _50packing_newcore.sh

