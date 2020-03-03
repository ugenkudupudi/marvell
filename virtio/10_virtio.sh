#!/bin/bash -x


dpdk-l2fwd -l 2,3 -n 2 \
	--no-pci \
	--vdev=virtio_user0,path=/usr/local/var/run/openvswitch/wan0 \
	--vdev=virtio_user1,path=/usr/local/var/run/openvswitch/wan1 \
	--file-prefix=container \
	--proc-type=auto \
	-- -q 8 -p 0x3 --no-mac-updating

