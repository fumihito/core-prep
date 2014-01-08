#!/bin/bash

# common(all arch)
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.10.25-saucy/linux-headers-3.10.25-031025_3.10.25-031025.201312201135_all.deb

# i386
wget \
    http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.10.25-saucy/linux-headers-3.10.25-031025-generic_3.10.25-031025.201312201135_i386.deb \
    http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.10.25-saucy/linux-image-3.10.25-031025-generic_3.10.25-031025.201312201135_i386.deb

tar cf kernel_i386_current.tar \
    linux-headers-3.10.25-031025_3.10.25-031025.201312201135_all.deb \
    linux-headers-3.10.25-031025-generic_3.10.25-031025.201312201135_i386.deb \
    linux-image-3.10.25-031025-generic_3.10.25-031025.201312201135_i386.deb

# amd64
wget \
    http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.10.25-saucy/linux-headers-3.10.25-031025-generic_3.10.25-031025.201312201135_amd64.deb \
    http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.10.25-saucy/linux-image-3.10.25-031025-generic_3.10.25-031025.201312201135_amd64.deb

tar cf kernel_amd64_current.tar \
    linux-headers-3.10.25-031025_3.10.25-031025.201312201135_all.deb \
    linux-headers-3.10.25-031025-generic_3.10.25-031025.201312201135_amd64.deb \
    linux-image-3.10.25-031025-generic_3.10.25-031025.201312201135_amd64.deb
