#!/bin/bash

./_get_kernel_i386.tar.sh
./_get_kernel_amd64.tar.sh


DEB_KERN_i386="\
    linux-headers-3.10.25-031025_3.10.25-031025.201312201135_all.deb \
    linux-headers-3.10.25-031025-generic_3.10.25-031025.201312201135_i386.deb \
    linux-image-3.10.25-031025-generic_3.10.25-031025.201312201135_i386.deb"
DEB_KERN_AMD64="\
    linux-headers-3.10.25-031025_3.10.25-031025.201312201135_all.deb \
    linux-headers-3.10.25-031025-generic_3.10.25-031025.201312201135_amd64.deb \
    linux-image-3.10.25-031025-generic_3.10.25-031025.201312201135_amd64.deb"

READY="go"
for i in ${DEB_KERN_i386} ${DEB_KERN_AMD64} ; do 
    if [ -f $i ] ; then
        sha1sum $i
    else
        echo "$i not found."
        READY="nogo"
    fi
done

if [ ${READY} == "go" ] ; then
    tar cf kernel_i386_current.tar ${DEB_KERN_i386}
    tar cf kernel_amd64_current.tar ${DEB_KERN_AMD64}
else
    echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
    echo "FATAL: Required files did not exists, please check *.deb files."
    echo "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
    exit 1
fi

