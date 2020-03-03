#!/bin/bash -x

export VHOST_SOCK_DIR=/usr/local/var/run/openvswitch
VHOST_USER_SOCKET_PATH_1=$VHOST_SOCK_DIR/dpdkvhostuser0
VHOST_USER_SOCKET_PATH_2=$VHOST_SOCK_DIR/dpdkvhostuser1

QEMU_CMD=qemu-system-aarch64
if [[ ! -f /usr/bin/$QEMU_CMD ]] ; then
   apt install $QEMU_CMD -y
fi

export GUEST_MEM=2048M
#export GUEST_MEM=3072M

$QEMU_CMD -name vm \
-machine virt,accel=kvm,usb=off \
-cpu host -m $GUEST_MEM \
-smp sockets=1,cores=2,threads=1 \
-object memory-backend-file,id=mem,size=$GUEST_MEM,mem-path=/mnt/huge,share=yes \
-numa node,memdev=mem -mem-prealloc \
-nographic -nodefaults \
-kernel /boot/Image \
-append "root=/dev/vda console=ttyAMA0 rw" \
-drive file=/root/rootfs.ext4,if=none,id=disk1,format=raw  \
-device virtio-blk-device,scsi=off,drive=disk1,id=virtio-disk1,bootindex=1 \
-serial stdio \
-chardev socket,id=char1,path=$VHOST_USER_SOCKET_PATH_1 \
-netdev type=vhost-user,id=mynet1,chardev=char1,vhostforce \
-device virtio-net-pci,mac=00:00:00:00:00:01,netdev=mynet1,mrg_rxbuf=off \
-chardev socket,id=char2,path=$VHOST_USER_SOCKET_PATH_2 \
-netdev type=vhost-user,id=mynet2,chardev=char2,vhostforce \
-device virtio-net-pci,mac=00:00:00:00:00:02,netdev=mynet2,mrg_rxbuf=off \
