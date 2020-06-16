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

#eth4 - 6
#eth5 - 7
#eth6 - 8
#eth7 - 9
#/usr/share/dpdk/usertools/dpdk-devbind.py --status
#for i in 2 3 4 5 6 7 8 9
for i in 6 7
do
	/usr/share/dpdk/usertools/dpdk-devbind.py -b vfio-pci 0002:0$i:00.0
done 
/usr/share/dpdk/usertools/dpdk-devbind.py --status

#. ./ovs_run.sh
# dpdk-l2fwd -l 2,3 -n 2 -- -q 8 -p 0x3 --no-mac-updating
