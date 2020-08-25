#!/bin/sh -x 

sudo ./create_bootdisk2.sh --dev /dev/sdb -w octeontx-bootfs-uboot.img -k Image -r rootfs.tar -e 4 -es MAX
