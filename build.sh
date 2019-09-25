#!/bin/bash -x

# env.sh should execute first
. $HOME/marvell/env.sh

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

source $TOOLS_HOME/unpack.sh
if [[ $? -ne 0 ]] ; then
  exit $?
fi

if [[ x$SOC_PLATFORM =~ ^xcn8[1,3]xx$ ]] ; then
   source $TOOLS_HOME/buildroot.sh
   if [[ $? -ne 0 ]] ; then
      exit $?
   fi
else
source $TOOLS_HOME/kernel.sh
if [[ $? -ne 0 ]] ; then
  exit $?
fi

source $TOOLS_HOME/musdk.sh
if [[ $? -ne 0 ]] ; then
  exit $?
fi

source $TOOLS_HOME/dpdk.sh
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
source $TOOLS_HOME/ovs.sh
if [[ $? -ne 0 ]] ; then
  exit $?
fi


# setup scripts the can run on DUT
if [[ -d $TFTPBOOT_DIR/root ]] ; then
rm -rf $TFTPBOOT_DIR/root
fi
cp -r $TOOLS_HOME/root $TFTPBOOT_DIR

if [[ ! -d $TFTPBOOT_DIR/boot ]] ; then
mkdir -p $TFTPBOOT_DIR/boot
fi
cp $KDIR/arch/arm64/boot/Image $TFTPBOOT_DIR/boot
cp $KDIR/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtb $TFTPBOOT_DIR/boot

cd $TFTPBOOT_DIR
if [[ $? -ne 0 ]] ; then
  exit $?
fi

# generate tarball that needs to be donwload from DUT
tar zcvf usr.tgz usr root boot lib
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
