#!/bin/sh -x

export TOOLS_HOME=$HOME/marvell
export RELEASE_ID=19.06.0
export BUILD_DIR_HOME=$HOME/mbin_build_dir_19_06_02
export SDK_TARBALL=$HOME/SDK10.0_19.06.0_sdk-sources-patches.zip
export DPDK_VERSION=dpdk-18.11-rc
export LINUX_VERSION=linux-4.14.76-rc
export TFTPBOOT_DIR=/tftpboot
export MUSDK_INSTALL_DIR=$TFTPBOOT_DIR/lib/modules/4.14.76-devel-19.02.1/kernel/drivers/musdk

export BASE_SOURCE=base-sources-rc
export DATAPLANE_SOURCE=dataplane-sources-rc
export SOURCES_LINUX=sources-$LINUX_VERSION
export SOURCES_DPDK=sources-$DPDK_VERSION
export SOURCES_MUSDK=sources-musdk-marvell-rc
export TOOLCHAIN_TARBALL=SDK10.0_19.06.0_sdk-toolchain
export MARVELL_TOOLCHAIN_HOME=marvell-tools-215
export PATH=$HOME:$BUILD_DIR_HOME/$MARVELL_TOOLCHAIN_HOME/bin:$PATH

export ARCH=arm64
export CROSS_COMPILE=aarch64-marvell-linux-gnu-
 
export CROSS=$CROSS_COMPILE
export KDIR=$BUILD_DIR_HOME/$LINUX_VERSION-$RELEASE_ID
export RTE_KERNELDIR=$KDIR
export RTE_TARGET=arm64-armada-linuxapp-gcc

export LIBMUSDK_HOME_PATH=$BUILD_DIR_HOME/musdk-marvell-rc-$RELEASE_ID
export LIBMUSDK_PATH=$LIBMUSDK_HOME_PATH/usr/local

export DPDK_HOME=$BUILD_DIR_HOME/$DPDK_VERSION-$RELEASE_ID

export DPDK_SHARE_FOR_EXAMPLES=$TFTPBOOT_DIR/usr/local/dpdk/share/dpdk
if [[ ! -d $DPDK_SHARE_FOR_EXAMPLES ]] ; then 
  mkdir -p $DPDK_SHARE_FOR_EXAMPLES
fi 


export OVS_VERSION=2.11.0
export OVS_DIR=openvswitch-$OVS_VERSION
export OVS_TARBALL_PATH=https://www.openvswitch.org/releases/$OVS_DIR.tar.gz
