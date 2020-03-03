#!/bin/bash

source env.sh

if [[ x$SOC_PLATFORM =~ ^xcn8[1,3]xx$ ]] ; then
    echo 
else
source dpdk.sh
if [[ $? -ne 0 ]] ; then
   exit 1;
fi
fi

locate qemu-img
if [[ $? -ne 0 ]] ; then
   sudo apt install qemu-utils -y
fi

# remove old rootfs
if [[ -f $ROOTFS_NAME ]] ; then 
   rm -rf $ROOTFS_NAME 
fi # end of -f

qemu-img create $ROOTFS_NAME $ROOTFS_SIZE
if [[ $? -ne 0 ]] ; then
    exit 1;
fi # end of qemu-img

mkfs.ext4 $ROOTFS_NAME
if [[ $? -ne 0 ]] ; then
   exit 1;
fi

if [[ ! -d $ROOTFS_LOCAL ]] ; then
	mkdir -p $ROOTFS_LOCAL
fi

sudo mount -o loop $ROOTFS_NAME $ROOTFS_LOCAL
if [[ $? -ne 0 ]] ; then
   exit 1;
fi

# TBD: add your extraction code here
cd $ROOTFS_LOCAL
if [[ $? -ne 0 ]] ; then
   sudo umount $ROOTFS_LOCAL
   exit 1;
fi

sudo tar xvf $EXTRACT_PRIMARY_FS .
if [[ $? -ne 0 ]] ; then
   sudo umount $ROOTFS_LOCAL
   exit 1;
fi

if [[ x$SOC_PLATFORM =~ ^xcn8[1,3]xx$ ]] ; then
    echo 
else
    sudo mv rootfs/* .
    if [[ $? -ne 0 ]] ; then
       sudo umount $ROOTFS_LOCAL
       exit 1;
    fi

    sudo rm -rf rootfs
    if [[ $? -ne 0 ]] ; then
       sudo umount $ROOTFS_LOCAL
       exit 1;
    fi

    if [[ -f $DPDK_VANILLA_ROOTFS.tgz ]] ; then
       #sudo tar zxvf $DPDK_VANILLA_ROOTFS.tgz
       sudo cp $DPDK_VANILLA_ROOTFS.tgz root
       if [[ $? -ne 0 ]] ; then
          sudo umount $ROOTFS_LOCAL
          exit 1;
       fi
    else # end if -f 
        echo $DPDK_VANILLA_ROOTFS.tgz "missing" 
        sudo umount $ROOTFS_LOCAL
        exit 1
    fi # endif of if  -f $DPDK_VANILLA_ROOTFS.tgz
fi # endif of SOC_PLATFORM != cn83xx

cd $WORK_DIR
if [[ $? -ne 0 ]] ; then
   sudo umount $ROOTFS_LOCAL
   exit 1;
fi

df -kh

sudo umount $ROOTFS_LOCAL
if [[ $? -ne 0 ]] ; then
   exit 1;
fi

echo
echo "ROOTFS is at" $ROOTFS_NAME
echo

echo "Helpfull Commands:"
echo "------------------"
echo 
echo "scp ugen@10.89.241.40:/tftpboot/rootfs.ext4 ."
echo
