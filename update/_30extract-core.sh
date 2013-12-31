#!/bin/bash

set -u
echo =====================
echo $0
echo =====================

echo ${DEBUGOUT:=/dev/null} > /dev/null
echo COREDIR=${COREDIR:=/mnt/root} > ${DEBUGOUT}

TARGET=${COREDIR}

WHOAMI=`whoami`
if [ "x_${WHOAMI}" != "x_root" ]; then
    echo "You must be root to do this operation."
    exit 1
fi


rm -rf ${TARGET}/* ${TARGET}/.*

echo "extracting ${1}"
tar xaf $1 -C ${TARGET}
