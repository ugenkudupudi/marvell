#!/bin/bash -x

export PATH=/usr/local/share/openvswitch/scripts:/usr/local/bin:/usr/local/sbin:$PATH

echo 2048 > /proc/sys/vm/nr_hugepages
#sysctl vm.nr_hugepages=1024
mkdir -p /dev/hugepages
mount -t hugetlbfs nodev /dev/hugepages
#mount -t hugetlbfs -o pagesize=1G none /dev/hugepages
grep HugePages_ /proc/meminfo

#awk '/Hugepagesize/ {print $2}' /proc/meminfo
#awk '/HugePages_Total/ {print $2} ' /proc/meminfo
#umount `awk '/hugetlbfs/ {print $2}' /proc/mounts`
#mkdir -p /mnt/huge
#mount -t hugetlbfs nodev /mnt/huge

#/usr/share/dpdk/usertools/dpdk-devbind.py --status
# eth0-wan0-dpdk-port0
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:00.1
# eth1-wan1-dpdk-port1
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:00.2
# eth2-wan2-dpdk-port2
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:00.3
# eth3-wan3-dpdk-port3
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:00.4
# eth3-wanx-dpdk-portx
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:00.5
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:00.6
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:00.7
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:01.0
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:01.1
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:01.2
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:01.3
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:01.4
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:01.5
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:01.6
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:01.7
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:02.0
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:02.1
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:02.2
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:02.3
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:02.4
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:02.5
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:02.6
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:02.7
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:03.0
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:03.1
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:03.2
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:03.3
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:03.4
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:03.5
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:03.6
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:03.7
/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0001:01:04.0
/usr/share/dpdk/usertools/dpdk-devbind.py --status

#. ./ovs_run.sh
# dpdk-l2fwd -l 2,3 -n 2 -- -q 8 -p 0x3 --no-mac-updating
