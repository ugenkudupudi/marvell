#!/bin/bash -x

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

echo "Build DPDK... "
cd $DPDK_VANILLA_DIR
if [[ $? -ne 0 ]] ; then
  exit $?
fi

if [[ ! -f config/defconfig_$DPDK_VANILLA_TARGET ]] ; then
   cp $DPDK_HOME/config/defconfig_$DPDK_VANILLA_TARGET config/
fi

make config T=$DPDK_VANILLA_TARGET
if [[ $? -ne 0 ]] ; then
  exit $?
fi

make -j8
if [[ $? -ne 0 ]] ; then
  exit $?
fi

rm $DPDK_VANILLA_TARGET
ln -s build $DPDK_VANILLA_TARGET
if [[ $? -ne 0 ]] ; then
  exit $?
fi

make -j8 examples T=$DPDK_VANILLA_TARGET
if [[ $? -ne 0 ]] ; then
  exit $?
fi

if [[ ! -d $DPDK_VANILLA_ROOTFS ]] ; then
mkdir -p $DPDK_VANILLA_ROOTFS
fi

make install DESTDIR=$DPDK_VANILLA_ROOTFS
if [[ $? -ne 0 ]] ; then
  exit $?
fi

cd .. 
#rm -rf $DPDK_VANILLA_ROOTFS/usr/local/share/dpdk/examples

cd $DPDK_VANILLA_ROOTFS/

tar zcvf $DPDK_VANILLA_ROOTFS.tgz *
if [[ $? -ne 0 ]] ; then
  exit $?
fi

rm -rf $DPDK_VANILLA_ROOTFS
