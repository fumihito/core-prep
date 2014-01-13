#!/bin/bash

FILE=$1
KERNELNAME=$2
export MASTER=172.20.200.20
export TARBALLNAME=ubuntu-core-12.04.3-core-i386_current.tar.gz
echo ${KERNELNAME:=kernel_i386_current.tar} > /dev/null
export KERNELNAME

export COREDIR=/mnt/root
export BOOTDIR=/mnt/boot
export COREDIR_BOOT=${COREROOT}/boot

export BOOTDEVICE=/dev/sda1
export COREDEVICE=/dev/sda3
export SUBDEVICE=/dev/sda4

export COREDOWNLOADURL=http://${MASTER}/ubuntu-core/${TARBALLNAME}
export KERNELDOWNLOADURL=http://${MASTER}/ubuntu-core/${KERNELNAME}

export DEFAULTUSER=ubuntu
export DEFAULTPASS=ubuntu


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

bash _40setup-kernel.sh
bash _50A_setup_syslinuxcfg.sh
bash _60_configure_initialuser.sh
