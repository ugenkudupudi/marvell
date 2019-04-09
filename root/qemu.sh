#!/bin/bash -x

QEMU_CMD=qemu-system-aarch64 
if [[ ! -f /usr/bin/$QEMU_CMD ]] ; then
   apt install $QEMU_CMD -y
fi

$QEMU_CMD -name vm \
-machine virt,accel=kvm,usb=off \
-cpu host -m 1024 \
-smp 2,sockets=1,cores=2,threads=1 \
-nographic -nodefaults \
-kernel /boot/Image \
-append "root=/dev/vda console=ttyAMA0 rw hugepagesz=512M hugepages=3" \
-drive file=/root/rootfs.ext4,if=none,id=disk1,format=raw  \
-device virtio-blk-device,scsi=off,drive=disk1,id=virtio-disk1,bootindex=1 \
-netdev user,id=eth0 -device virtio-net-device,netdev=eth0 \
-serial stdio \
-mem-path /dev/huge

-chardev socket,id=char1,path=/usr/local/var/run/openvswitch/vhost-user0 -netdev type=vhost-user,id=mynet1,chardev=char1,vhostforce,queues=2 \
-netdev user,id=eth0 -device virtio-net-device,netdev=eth0 \

