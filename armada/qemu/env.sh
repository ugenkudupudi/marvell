#!/bin/bash -x

source ../env.sh

WORK_DIR=$HOME/marvell/qemu

# rootfs
ROOTFS_LOCAL=$WORK_DIR/rootfs_local
ROOTFS_NAME=$TFTPBOOT_DIR/rootfs.ext4
ROOTFS_SIZE=2G
#EXTRACT_PRIMARY_FS=$BUILD_DIR_HOME/${SOC_PLATFORM}-release-output/image/rootfs.tar
EXTRACT_PRIMARY_FS=/home/ugen/build_cn83xx/cn83xx/rootfs-SDK10.0-PR2003.tar


# dpdk
DPDK_VANILLA_VERSION=18.11
DPDK_VANILLA_DIR=$WORK_DIR/dpdk-$DPDK_VANILLA_VERSION
DPDK_VANILLA_DIR_TAR=dpdk-$DPDK_VANILLA_VERSION.tar.xz
DPDK_VANILLA_TARBALL=https://fast.dpdk.org/rel/$DPDK_VANILLA_DIR_TAR
DPDK_VANILLA_ROOTFS=$WORK_DIR/dpdk_rootfs

DPDK_VANILLA_TARGET=arm64-armada-linuxapp-gcc

