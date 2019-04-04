#!/bin/bash

source env.sh

locate qemu-img
if [[ $? -ne 0 ]] ; then
   sudo apt install qemu-utils -y
fi

if [[ ! -f $ROOTFS_NAME ]] ; then 
   qemu-img create $ROOTFS_NAME $ROOTFS_SIZE
   if [[ $? -ne 0 ]] ; then
	exit 1;
   fi # end of qemu-img

   mkfs.ext4 $ROOTFS_NAME
   if [[ $? -ne 0 ]] ; then
	exit 1;
   fi
fi # end of -f

if [[ ! -d $ROOTFS_LOCAL ]] ; then
	mkdir -p $ROOTFS_LOCAL
fi

sudo mount -o loop $ROOTFS_NAME $ROOTFS_LOCAL
if [[ $? -ne 0 ]] ; then
	exit 1;
fi

# TBD: add your extraction code here
cd $ROOTFS_LOCAL

sudo tar zxvf  $EXTRACT_PRIMARY_FS .

sudo mv rootfs/* .
sudo rm -rf rootfs
ls

if [[ -f $DPDK_VANILLA_ROOTFS.tgz ]] ; then
sudo tar zxvf $DPDK_VANILLA_ROOTFS.tgz
else
echo $DPDK_VANILLA_ROOTFS.tgz "missing" 
exit 1
fi

cd -

df -kh

sudo umount $ROOTFS_LOCAL

echo
echo "ROOTFS is at" $ROOTFS_NAME
echo

