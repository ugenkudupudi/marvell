#!/bin/bash -x

docker run --rm -it --privileged \
	-v /sys/bus/pci/devices:/sys/bus/pci/devices \
	-v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages \
	-v /sys/devices/system/node:/sys/devices/system/node \
	-v /usr/local/var/run/openvswitch:/usr/local/var/run/openvswitch \
	-v /dev:/dev \
	ugenmarvell/dpdk dpdk-l2fwd -l 3 -n 1 \
	--no-pci \
	--vdev=virtio_user0,path=/usr/local/var/run/openvswitch/vhostwan0 \
	--vdev=virtio_user1,path=/usr/local/var/run/openvswitch/vhostlo0 \
	--file-prefix=container \
	--proc-type=auto \
	-- -q 8 -p 0x3 --no-mac-updating

