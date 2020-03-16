#!/bin/bash -x

#/bin/dpdk-l2fwd -l 2,3 -n 2 \
#	--no-pci \
#	--vdev=virtio_user0,path=/usr/local/var/run/openvswitch/vhostwan0 \
#	--vdev=virtio_user1,path=/usr/local/var/run/openvswitch/vhostwan1 \
#	--proc-type=auto \
#	--file-prefix=container-l2fwd \
#	-- -q 8 -p 0x3 --no-mac-updating

/bin/dpdk-l3fwd -l 2 -n 1 \
	--no-pci \
	--vdev=virtio_user0,path=/usr/local/var/run/openvswitch/vhostwan0 \
	--vdev=virtio_user1,path=/usr/local/var/run/openvswitch/vhostwan1 \
	--proc-type=auto \
	--file-prefix=container-l3fwd \
	-- -p 0x3 --config="(0,0,2),(1,0,2)" --parse-ptype  \
        --eth-dest=0,00:0f:b7:c8:07:c8 --eth-dest=1,00:0f:b7:30:40:04
