#!/bin/bash

source env.sh

echo "Get DPDK Source ... " ${DPDK_VANILLA_TARBALL}
if [[ ! -f $DPDK_VANILLA_DIR_TAR ]] ; then
   wget ${DPDK_VANILLA_TARBALL}
   if [[ $? -ne 0 ]] ; then
     exit $?
   fi
fi 

if [[ ! -d ${DPDK_VANILLA_DIR} ]] ; then
   tar -vxJf $DPDK_VANILLA_DIR_TAR
   if [[ $? -ne 0 ]] ; then
     exit $?
   fi 
fi 

echo "Build Vanilla DPDK... "
cd $DPDK_VANILLA_DIR
if [[ $? -ne 0 ]] ; then
  exit $?
fi

echo "Copy Armada DPDK config file... "
if [[ ! -f config/defconfig_$DPDK_VANILLA_TARGET ]] ; then
   cp $DPDK_HOME/config/defconfig_$DPDK_VANILLA_TARGET $DPDK_VANILLA_DIR/config/
if [[ $? -ne 0 ]] ; then
  exit $?
fi
   cp $DPDK_HOME/config/arm/arm64_armada_linuxapp_gcc $DPDK_VANILLA_DIR/config/arm/
if [[ $? -ne 0 ]] ; then
  exit $?
fi
fi

if [[ ! -f config/.config ]]; then
echo "Set Armada DPDK config"
make config T=$DPDK_VANILLA_TARGET
if [[ $? -ne 0 ]] ; then
  exit $?
fi
fi

echo "Build Vanilla DPDK for" $ARCH
make -j8
if [[ $? -ne 0 ]] ; then
  exit $?
fi

rm $DPDK_VANILLA_TARGET
ln -s build $DPDK_VANILLA_TARGET
if [[ $? -ne 0 ]] ; then
  exit $?
fi

#echo "Build Vanilla DPDK examples for" $ARCH
#make -j8 examples T=$DPDK_VANILLA_TARGET
#if [[ $? -ne 0 ]] ; then
#  exit $?
#fi

if [[ ! -d $DPDK_VANILLA_ROOTFS ]] ; then
mkdir -p $DPDK_VANILLA_ROOTFS
fi

echo "Install the final Vanilla binaries and libs for" $ARCH
make install DESTDIR=$DPDK_VANILLA_ROOTFS
if [[ $? -ne 0 ]] ; then
  exit $?
fi

cd .. 

echo "Create" $DPDK_VANILLA_ROOTFS "rootfs"
cd $DPDK_VANILLA_ROOTFS/

tar zcvf $DPDK_VANILLA_ROOTFS.tgz *
if [[ $? -ne 0 ]] ; then
  exit $?
fi

rm -rf $DPDK_VANILLA_ROOTFS
echo
echo "Vanilla DPDK binaries and libs for" $ARCH "is at" $DPDK_VANILLA_ROOTFS.tgz 
echo 
