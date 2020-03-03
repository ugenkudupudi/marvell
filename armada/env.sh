#!/bin/sh -x

# Change Me: base directory configuation

# SDK Release ID
export RELEASE_ID=SDK10.0-PR2003

# Platform ID (cn83xx,cn81xx,cn913x etc)
export SOC_PLATFORM=cn83xx

# TODO: delete me
# Build directory; place all tarballs here
#export BASE_HOME=$HOME/build_${SOC_PLATFORM}

# Work directory ; change this according to builds (armada/cn83xx etc)
export BUILD_DIR_HOME=$HOME/work_${SOC_PLATFORM}_${RELEASE_ID}

# Main SDK tarball
export SDK_TARBALL=$HOME/base_sdk-${RELEASE_ID}.zip

# toolchain
export MARVELL_TOOLCHAIN_HOME=marvell-tools-238.0
export TOOLCHAIN_TARBALL=${HOME}/toolchain-238.tar.bz2

# Env Variables
export TOOLS_HOME=$HOME/marvell

export BASE_SRC=base-sources-${RELEASE_ID}
export BASE_SRC_TARBALL=${BUILD_DIR_HOME}/${BASE_SRC}.tar.bz2

export SRC_BUILDROOT=sources-buildroot-${RELEASE_ID}
export SRC_BUILDROOT_TARBALL=${BUILD_DIR_HOME}/${SRC_BUILDROOT}.tar.bz2


export SRC_BUILDROOT_EXT=sources-buildroot-external-marvell-${RELEASE_ID}
export SRC_BUILDROOT_EXT_TARBALL=${BUILD_DIR_HOME}/${SRC_BUILDROOT_EXT}.tar.bz2


export DPDK_VERSION=dpdk-18.11-rc
export LINUX_VERSION=linux-4.14.76-rc
export TFTPBOOT_DIR=/tftpboot
export MUSDK_INSTALL_DIR=$TFTPBOOT_DIR/lib/modules/4.14.76-devel-19.02.1/kernel/drivers/musdk

export BASE_SOURCE=sources-buildroot-SDK10.0
export DATAPLANE_SOURCE=dataplane-sources-rc
export SOURCES_LINUX=sources-$LINUX_VERSION
export SOURCES_DPDK=sources-$DPDK_VERSION
export SOURCES_MUSDK=sources-musdk-marvell-rc

export ARCH=arm64
export CROSS_COMPILE=aarch64-marvell-linux-gnu-
 
export CROSS=$CROSS_COMPILE
export KDIR=$BUILD_DIR_HOME/$LINUX_VERSION-$RELEASE_ID
export RTE_KERNELDIR=$KDIR
export RTE_TARGET=arm64-armada-linuxapp-gcc

export LIBMUSDK_HOME_PATH=$BUILD_DIR_HOME/musdk-marvell-rc-$RELEASE_ID
export LIBMUSDK_PATH=$LIBMUSDK_HOME_PATH/usr/local

if [[ x$SOC_PLATFORM =~ ^xcn8[1,3]xx$ ]] ; then
export DPDK_HOME=$BUILD_DIR_HOME/$SOC_PLATFORM-release-output/build/dpdk
else
export DPDK_HOME=$BUILD_DIR_HOME/$DPDK_VERSION-$RELEASE_ID
fi

export DPDK_SHARE_FOR_EXAMPLES=$TFTPBOOT_DIR/usr/local/dpdk/share/dpdk
if [[ ! -d $DPDK_SHARE_FOR_EXAMPLES ]] ; then 
  mkdir -p $DPDK_SHARE_FOR_EXAMPLES
fi 


export OVS_VERSION=2.11.1
export OVS_DIR=openvswitch-$OVS_VERSION
export OVS_TARBALL_PATH=https://www.openvswitch.org/releases/$OVS_DIR.tar.gz
#export OVS_MOUNT_DISK_PATH=$TFTPBOOT_DIR
export OVS_MOUNT_DISK_PATH=$HOME/marvell/disk

# Set the path to access Toolchain
export PATH=$HOME:$BUILD_DIR_HOME/$MARVELL_TOOLCHAIN_HOME/bin:$PATH
