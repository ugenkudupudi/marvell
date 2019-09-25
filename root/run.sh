#!/bin/bash -x

ip link set dev eth0 up
ip link set dev eth1 up

sleep 3 

echo 2048 > /proc/sys/vm/nr_hugepages
mkdir -p /dev/hugepages
mount -t hugetlbfs nodev /dev/hugepages
grep HugePages_ /proc/meminfo

/usr/share/dpdk/usertools/dpdk-devbind.py --status
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:00.1
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:00.2
/usr/share/dpdk/usertools/dpdk-devbind.py --status

testpmd -w 0001:01:00.1 -w 0001:01:00.2 -c f -- \
  --burst=256 --txd=2048 --rxd=1024 --rxq=1 --txq=1 --nb-cores=1 \
  --coremask 2 -a --forward-mode=io
