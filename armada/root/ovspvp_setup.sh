#!/bin/bash -x

# Setup the OVS+DPDK 

#apt-get install libatomic1

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

ip link set dev eth0 up
ip link set dev eth1 up

sleep 3
echo 2048 > /proc/sys/vm/nr_hugepages
mkdir -p /dev/hugepages
mount -t hugetlbfs nodev /dev/hugepages
grep HugePages_ /proc/meminfo


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
 
ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-socket-mem="8192"
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
