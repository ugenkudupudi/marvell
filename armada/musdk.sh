#!/bin/bash -x

if [[ ! -d $MUSDK_INSTALL_DIR ]] ; then
  mkdir -p $MUSDK_INSTALL_DIR
fi

echo "Build MUSDK... "

cd $LIBMUSDK_HOME_PATH/modules/cma
if [[ $? -ne 0 ]] ; then
  exit $?
fi

make
if [[ $? -ne 0 ]] ; then
  exit $?
fi

cp musdk_cma.ko $MUSDK_INSTALL_DIR
if [[ $? -ne 0 ]] ; then
  exit $?
fi

cd $LIBMUSDK_HOME_PATH/modules/sam
if [[ $? -ne 0 ]] ; then
  exit $?
fi

make
if [[ $? -ne 0 ]] ; then
  exit $?
fi

cp mv_sam_uio.ko $MUSDK_INSTALL_DIR 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

cd $LIBMUSDK_HOME_PATH/modules/dmax2
if [[ $? -ne 0 ]] ; then
  exit $?
fi

make
if [[ $? -ne 0 ]] ; then
  exit $?
fi

cp mv_dmax2_uio.ko $MUSDK_INSTALL_DIR
if [[ $? -ne 0 ]] ; then
  exit $?
fi

echo "Configure and build MUSDK"

cd $LIBMUSDK_HOME_PATH
if [[ $? -ne 0 ]] ; then
  exit $?
fi

./bootstrap
if [[ $? -ne 0 ]] ; then
  exit $?
fi

./configure 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

make -j8
if [[ $? -ne 0 ]] ; then
  exit $?
fi

if [[ -d ./usr/local ]] ; then
  rm -rf ./usr
fi

make install
if [[ $? -ne 0 ]] ; then
  exit $?
fi

