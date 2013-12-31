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

WORKDIR=`pwd`

tar czf _installed_packages.tgz   _installed_packages/

CORETAR="${WORKDIR}/ubuntu-core-`date "+%F_%H%M_%s"`.tar.gz"
(cd "${COREDIR}"; tar czfp "${CORETAR}" *)

rm -f               "${WORKDIR}/ubuntu-core-current"
ln -sf "${CORETAR}" "${WORKDIR}/ubuntu-core-current"

