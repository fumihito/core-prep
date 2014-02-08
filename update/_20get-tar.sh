#!/bin/bash

set -u

echo ${DEBUGOUT:=/dev/null} > /dev/null

echo MASTER=${MASTER:=172.20.200.20}                 > ${DEBUGOUT}
echo TARBALLNAME=${TARBALLNAME:=ubuntu-core-12.04.4-core-amd64_current.tar.gz} > ${DEBUGOUT}
echo COREDOWNLOADURL=${COREDOWNLOADURL:=http://${MASTER}/ubuntu-core/${TARBALLNAME}} > ${DEBUGOUT}
echo TEMPDIR=${TEMPDIR:=`mktemp -d /tmp/$0.XXXXXXX`} > ${DEBUGOUT}

if [ -n "${TEMPDIR}" ] ; then
   TARBALLPATH=${TEMPDIR}/${TARBALLNAME}
else
   exit 10
fi

wget ${COREDOWNLOADURL} -O ${TARBALLPATH} -o /dev/null \
&&  echo ${TARBALLPATH}
