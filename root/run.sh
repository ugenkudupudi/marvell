#!/bin/bash

ip link set dev eth0 up
ip link set dev eth1 up

sleep 3 

cat /proc/mounts | grep -q hugetlbfs || \
  $(mkdir -p /mnt/huge; mount -t hugetlbfs nodev /mnt/huge)
if [[ $? -ne 0 ]] ; then
  exit $?
fi

echo 1024 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

if [[ $? -ne 0 ]] ; then
  exit $?
fi

insmod /usr/lib/modules/musdk/musdk_cma.ko
if [[ $? -ne 0 ]] ; then
  exit $?
fi

rmmod uio_pdrv_genirq.ko
insmod /usr/lib/modules/4.14.76-devel-19.02.1/kernel/drivers/uio/uio_pdrv_genirq.ko of_id="generic-uio"
if [[ $? -ne 0 ]] ; then
  exit $?
fi

/usr/local/dpdk/bin/testpmd --vdev=net_mvpp2,iface=eth0,iface=eth1 -c f -- \
  --burst=256 --txd=2048 --rxd=1024 --rxq=1 --txq=1 --nb-cores=1 \
  --coremask 2 -a --forward-mode=io
