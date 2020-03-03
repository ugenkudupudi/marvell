#!/bin/bash -x

cd $KDIR
if [[ $? -ne 0 ]] ; then
  exit $?
fi
 
patch -p1 < $LIBMUSDK_HOME_PATH/patches/linux-4.14/0001-dts-musdk-cma-memory.patch
if [[ $? -ne 0 ]] ; then
  exit $?
fi
 
patch -p1 < $LIBMUSDK_HOME_PATH/patches/linux-4.14/0002-dts-musdk-sam.patch
if [[ $? -ne 0 ]] ; then
  exit $?
fi
 
patch -p1 < $LIBMUSDK_HOME_PATH/patches/linux-4.14/0003-dts-musdk-xor.patch
if [[ $? -ne 0 ]] ; then
  exit $?
fi
 
patch -p1 < $LIBMUSDK_HOME_PATH/patches/linux-4.14/0004-dts-musdk-pp2.patch
if [[ $? -ne 0 ]] ; then
  exit $?
fi
 
patch -p1 < $LIBMUSDK_HOME_PATH/patches/linux-4.14/0005-dts-musdk-neta.patch
if [[ $? -ne 0 ]] ; then
  exit $?
fi
 
patch -p1 < $LIBMUSDK_HOME_PATH/patches/linux-4.14/0006-dts-musdk-agnic.patch
if [[ $? -ne 0 ]] ; then
  exit $?
fi
 
patch -p1 < $LIBMUSDK_HOME_PATH/patches/linux-4.14/0007-mvpp2-add-MUSDK-compatibility-for-RSS.patch
if [[ $? -ne 0 ]] ; then
  exit $?
fi
 
patch -p1 < $LIBMUSDK_HOME_PATH/patches/linux-4.14/0008-generic-uio-allow-attaching-up-to-4-devices.patch
if [[ $? -ne 0 ]] ; then
  exit $?
fi
 

