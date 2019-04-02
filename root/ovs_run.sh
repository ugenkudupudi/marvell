#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

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

rmmod uio_pdrv_genirq.ko
insmod /usr/lib/modules/4.14.76-devel-19.02.1/kernel/drivers/uio/uio_pdrv_genirq.ko of_id="generic-uio"

rm -rf /usr/local/var/run/openvswitch/ ; rm -rf /usr/local/etc/openvswitch/ ; mkdir -p /usr/local/var/run/openvswitch/ ; mkdir -p /usr/local/etc/openvswitch/ ; rm -f /tmp/conf.db ; mkdir -p /usr/local/etc/openvswitch ; mkdir -p /usr/local/var/run/openvswitch ; ovsdb-tool create /usr/local/etc/openvswitch/conf.db /usr/local/share/openvswitch/vswitch.ovsschema 
 
 
ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock --remote=db:Open_vSwitch,Open_vSwitch,manager_options --pidfile --detach ; export DB_SOCK=/usr/local/var/run/openvswitch/db.sock ; ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true ; ovs-vsctl --no-wait init 
 
ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-socket-mem="2048" ; 
 
ovs-vswitchd unix:$DB_SOCK --pidfile --detach --log-file=/var/log/ovs-vswitchd.log 
 
ovs-vsctl add-br br0 -- set Bridge br0 datapath_type=netdev 

ovs-vsctl add-port br0 dpdk0 -- set Interface dpdk0 type=dpdk \
    options:dpdk-devargs=eth_mvpp20,iface=eth0

sleep 3
 
ovs-vsctl add-port br0 dpdk1 -- set Interface dpdk1 type=dpdk \
    options:dpdk-devargs=eth_mvpp21,iface=eth1
sleep 3

ovs-ofctl del-flows br0 ; ovs-ofctl add-flow br0 in_port=1,action=output:2; ovs-ofctl add-flow br0 in_port=2,action=output:1 
  
ovs-vsctl --no-wait set Open_vSwitch . other_config:pmd-cpu-mask=0x2

#/usr/local/dpdk/bin/testpmd --no-pci -c f -- \
#--burst=256 --txd=2048 --rxd=1024 --rxq=1 --txq=1 --nb-cores=1 \
#--coremask 2 -a --forward-mode=io  
