#!/bin/bash

# common(all arch)

if [ ! -f linux-headers-3.10.25-031025_3.10.25-031025.201312201135_all.deb ] ; then
    wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.10.25-saucy/linux-headers-3.10.25-031025_3.10.25-031025.201312201135_all.deb
else
    echo "linux-headers.(snip).all.deb are already donwloaded. "
fi

# i386

wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.10.25-saucy/linux-headers-3.10.25-031025-generic_3.10.25-031025.201312201135_i386.deb
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.10.25-saucy/linux-image-3.10.25-031025-generic_3.10.25-031025.201312201135_i386.deb

