#!/bin/bash -x

#apt-get install libatomic1

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

ip link set dev eth0 up
ip link set dev eth1 up

#sleep 3

cat /proc/mounts | grep -q hugetlbfs || \
  $(mkdir -p /mnt/huge; mount -t hugetlbfs nodev /mnt/huge)
if [[ $? -ne 0 ]] ; then
  exit $?
fi

echo 1024 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
if [[ $? -ne 0 ]] ; then
  exit $?
fi

rmmod musdk_cma.ko
insmod /lib/modules/`uname -r`/kernel/drivers/musdk/musdk_cma.ko
if [[ $? -ne 0 ]] ; then
  exit $?
fi


rmmod uio_pdrv_genirq.ko
insmod /lib/modules/`uname -r`/kernel/drivers/uio/uio_pdrv_genirq.ko of_id="generic-uio"
if [[ $? -ne 0 ]] ; then
  exit $?
fi


rm -rf /usr/local/var/run/openvswitch/ ; 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

rm -rf /usr/local/etc/openvswitch/ ; 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

mkdir -p /usr/local/var/run/openvswitch/ ; 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

mkdir -p /usr/local/etc/openvswitch/ ; 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

rm -f /tmp/conf.db ; 

mkdir -p /usr/local/etc/openvswitch ; 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

mkdir -p /usr/local/var/run/openvswitch ; 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

ovsdb-tool create /usr/local/etc/openvswitch/conf.db /usr/local/share/openvswitch/vswitch.ovsschema 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

 
ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock --remote=db:Open_vSwitch,Open_vSwitch,manager_options --pidfile --detach ; 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

export DB_SOCK=/usr/local/var/run/openvswitch/db.sock ; 

ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true ; 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

ovs-vsctl --no-wait init 
if [[ $? -ne 0 ]] ; then
  exit $?
fi
 
ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-socket-mem="2048" ; 
if [[ $? -ne 0 ]] ; then
  exit $?
fi
 
ovs-vswitchd unix:$DB_SOCK --pidfile --detach --log-file=/var/log/ovs-vswitchd.log 
if [[ $? -ne 0 ]] ; then
  exit $?
fi
 
# Bridge 
ovs-vsctl add-br br0 -- set Bridge br0 datapath_type=netdev 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

# Ports

ovs-vsctl add-port br0 dpdk0 -- set Interface dpdk0 type=dpdk \
    options:dpdk-devargs=eth_mvpp20,iface=eth0 ofport_request=1
if [[ $? -ne 0 ]] ; then
  exit $?
fi


sleep 3
 
ovs-vsctl add-port br0 dpdk1 -- set Interface dpdk1 type=dpdk \
    options:dpdk-devargs=eth_mvpp21,iface=eth1 ofport_request=2
if [[ $? -ne 0 ]] ; then
  exit $?
fi

sleep 3

# Add two dpdkvhostuser ports
#ovs-vsctl add-port br0 dpdkvhostuser0 \
#    -- set Interface dpdkvhostuser0 type=dpdkvhostuser ofport_request=3
#ovs-vsctl add-port br0 dpdkvhostuser1 \
#    -- set Interface dpdkvhostuser1 type=dpdkvhostuser ofport_request=4

# Add two dpdkvhost-user-client ports
VHOST_USER_SOCKET_PATH_1=/tmp/vhost-user-socket-1
VHOST_USER_SOCKET_PATH_2=/tmp/vhost-user-socket-2

ovs-vsctl add-port br0 vhost-client-1 \
    -- set Interface vhost-client-1 type=dpdkvhostuserclient \
         options:vhost-server-path=$VHOST_USER_SOCKET_PATH_1 ofport_request=3
if [[ $? -ne 0 ]] ; then
  exit $?
fi

ovs-vsctl add-port br0 vhost-client-2 \
    -- set Interface vhost-client-2 type=dpdkvhostuserclient \
         options:vhost-server-path=$VHOST_USER_SOCKET_PATH_2 ofport_request=4
if [[ $? -ne 0 ]] ; then
  exit $?
fi

# Flows

ovs-ofctl del-flows br0 ; 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

ovs-ofctl add-flow br0 in_port=1,action=output:3
if [[ $? -ne 0 ]] ; then
  exit $?
fi

ovs-ofctl add-flow br0 in_port=3,action=output:1 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

ovs-ofctl add-flow br0 in_port=4,action=output:2 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

ovs-ofctl add-flow br0 in_port=2,action=output:4 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

ovs-ofctl dump-flows br0

ovs-vsctl --no-wait set Open_vSwitch . other_config:pmd-cpu-mask=0x2
if [[ $? -ne 0 ]] ; then
  exit $?
fi

