#!/bin/bash -x

# env.sh should execute first
. $HOME/env.sh

# check for build directory
if [[ x$BUILD_DIR_HOME != x ]] ; then
  if [[ ! -d $BUILD_DIR_HOME ]] ; then
     mkdir -p $BUILD_DIR_HOME
  
     cd $BUILD_DIR_HOME
     if [[ $? -ne 0 ]] ; then
         exit $?
     fi
     unzip $SDK_TARBALL
  fi # end of -d
else # else x != x
  exit 1
fi #end of x != x

# cleanup TFTP boot dir
if [[ x$TFTPBOOT_DIR != x ]] ; then
rm -rf $TFTPBOOT_DIR/*
else
exit 1
fi

source $HOME/unpack.sh
if [[ $? -ne 0 ]] ; then
  exit $?
fi

source $HOME/kernel.sh
if [[ $? -ne 0 ]] ; then
  exit $?
fi

source $HOME/musdk.sh
if [[ $? -ne 0 ]] ; then
  exit $?
fi

source $HOME/dpdk.sh
if [[ $? -ne 0 ]] ; then
  exit $?
fi

# copy MUSDK linux modules (.ko's) to tftpboot
cd $LIBMUSDK_HOME_PATH
if [[ $? -ne 0 ]] ; then
  exit $?
fi

cp -r usr $TFTPBOOT_DIR
if [[ $? -ne 0 ]] ; then
  exit $?
fi

# copy DPDK kernel modules and sample applications to tftpboot
cd $DPDK_HOME
if [[ $? -ne 0 ]] ; then
  exit $?
fi

if [[ ! -d $DPDK_SHARE_FOR_EXAMPLES ]] ; then
   mkdir -p $DPDK_SHARE_FOR_EXAMPLES
fi

cp -r examples $DPDK_SHARE_FOR_EXAMPLES
if [[ $? -ne 0 ]] ; then
  exit $?
fi

# build ovs and install under usr/local
source $HOME/ovs.sh
if [[ $? -ne 0 ]] ; then
  exit $?
fi


# setup scripts the can run on DUT
if [[ ! -d $TFTPBOOT_DIR/root ]] ; then
mkdir -p $TFTPBOOT_DIR/root
cp $HOME/run.sh $TFTPBOOT_DIR/root
cp $HOME/ovs_run.sh $TFTPBOOT_DIR/root
fi

if [[ ! -d $TFTPBOOT_DIR/boot ]] ; then
mkdir -p $TFTPBOOT_DIR/boot
cp $KDIR/arch/arm64/boot/Image $TFTPBOOT_DIR/boot
cp $KDIR/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtb $TFTPBOOT_DIR/boot
fi

cd $TFTPBOOT_DIR
if [[ $? -ne 0 ]] ; then
  exit $?
fi

# generate tarball that needs to be donwload from DUT
tar zcvf usr.tgz usr root boot
if [[ $? -ne 0 ]] ; then
  exit $?
fi

# copy kernel images
cp $KDIR/arch/arm64/boot/Image dpdkImage 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

# copy dtb file
cp $KDIR/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtb dpdk-armada-8040-mcbin.dtb
if [[ $? -ne 0 ]] ; then
  exit $?
fi

ls $TFTPBOOT_DIR
