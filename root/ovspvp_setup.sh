#!/bin/bash -x

# Setup the OVS+DPDK 

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


# cleanup old OVS configuration
rm -rf /usr/local/var/run/openvswitch
if [[ $? -ne 0 ]] ; then
  exit $?
fi

rm -rf /usr/local/etc/openvswitch
if [[ $? -ne 0 ]] ; then
  exit $?
fi

mkdir -p /usr/local/var/run/openvswitch
if [[ $? -ne 0 ]] ; then
  exit $?
fi

mkdir -p /usr/local/etc/openvswitch
if [[ $? -ne 0 ]] ; then
  exit $?
fi

rm -f /usr/local/etc/openvswitch/conf.db

mkdir -p /usr/local/etc/openvswitch
if [[ $? -ne 0 ]] ; then
  exit $?
fi

mkdir -p /usr/local/var/run/openvswitch
if [[ $? -ne 0 ]] ; then
  exit $?
fi

# Initialize OVS

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
 
ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-socket-mem="2048"
if [[ $? -ne 0 ]] ; then
  exit $?
fi
 
ovs-vswitchd unix:$DB_SOCK --pidfile --detach --log-file=/var/log/ovs-vswitchd.log 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

#ovs-vsctl --no-wait set Open_vSwitch . other_config:pmd-cpu-mask=0x2
#if [[ $? -ne 0 ]] ; then
#  exit $?
#fi
