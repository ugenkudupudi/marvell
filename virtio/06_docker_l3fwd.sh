#!/bin/bash -x

docker run --rm -it --privileged \
	-v /sys/bus/pci/devices:/sys/bus/pci/devices \
	-v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages \
	-v /sys/devices/system/node:/sys/devices/system/node \
	-v /usr/local/var/run/openvswitch:/usr/local/var/run/openvswitch \
	-v /dev:/dev \
	ugenmarvell/dpdk dpdk-l3fwd -l 2 -n 2 \
	--no-pci \
	--vdev=virtio_user0,path=/usr/local/var/run/openvswitch/vhostwan0 \
	--vdev=virtio_user1,path=/usr/local/var/run/openvswitch/vhostwan1 \
	--file-prefix=docker-l3fwd \
	--proc-type=auto \
	-- -p 0x3 --config="(0,0,2),(1,0,2)"  --parse-ptype  \
        --eth-dest=0,00:0f:b7:c8:07:c8 --eth-dest=1,00:0f:b7:30:40:04

