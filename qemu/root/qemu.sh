qemu-system-aarch64 -name vm \
-machine virt,accel=kvm,usb=off \
-cpu host -m 512 \
-smp 2,sockets=1,cores=2,threads=1 \
-nographic -nodefaults \
-kernel /boot/Image \
-append "root=/dev/vda console=ttyAMA0 rw hugepagesz=512M hugepages=3" \
-drive file=/root/rootfs.ext4,if=none,id=disk1,format=raw  \
-device virtio-blk-device,scsi=off,drive=disk1,id=virtio-disk1,bootindex=1 \
-netdev user,id=eth0 -device virtio-net-device,netdev=eth0 \
-serial stdio \
-mem-path /dev/huge

