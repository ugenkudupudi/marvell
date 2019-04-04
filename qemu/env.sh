#!/bin/bash -x

source ../env.sh

# rootfs
ROOTFS_LOCAL=rootfs_local
ROOTFS_NAME=$TFTPBOOT_DIR/rootfs.ext4
ROOTFS_SIZE=6G
EXTRACT_PRIMARY_FS=$HOME/a80x0/rootfs/buildroot-2018.11-19.01.0-armv8le.tgz

# dpdk
DPDK_VANILLA_VERSION=18.11
DPDK_VANILLA_DIR=dpdk-$DPDK_VANILLA_VERSION
DPDK_VANILLA_DIR_TAR=$DPDK_VANILLA_DIR.tar.xz
DPDK_VANILLA_TARBALL=https://fast.dpdk.org/rel/$DPDK_VANILLA_DIR_TAR
DPDK_VANILLA_ROOTFS=$HOME/marvell/qemu/dpdk_rootfs

DPDK_VANILLA_TARGET=arm64-armada-linuxapp-gcc
