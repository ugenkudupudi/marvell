#!/bin/bash -x

#mode="hostuser"

lsmod | grep musdk_cma
if [[ $? -ne 0 ]] ; then
    source ovspvp_setup.sh 
    if [[ $? -ne 0 ]] ; then
       exit $?
    fi
fi

ovs-vsctl --if-exists del-br br0

# Bridge 
ovs-vsctl add-br br0 -- set Bridge br0 datapath_type=netdev 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

# Ports

# 172.16.1.1
ovs-vsctl add-port br0 dpdk0 -- set Interface dpdk0 type=dpdk \
    ofport=1 \
    options:dpdk-devargs=eth_mvpp20,iface=eth0  
if [[ $? -ne 0 ]] ; then
  exit $?
fi

# 192.168.1.1
ovs-vsctl add-port br0 dpdk1 -- set Interface dpdk1 type=dpdk \
    ofport=2 \
    options:dpdk-devargs=eth_mvpp21,iface=eth1 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

if [[ x$mode = x"hostuser" ]] ; then
# Add two dpdkvhostuser ports
ovs-vsctl add-port br0 dpdkvhostuser0 \
    -- set Interface dpdkvhostuser0 type=dpdkvhostuser ofport_request=3
if [[ $? -ne 0 ]] ; then
  exit $?
fi

ovs-vsctl add-port br0 dpdkvhostuser1 \
    -- set Interface dpdkvhostuser1 type=dpdkvhostuser ofport_request=4
if [[ $? -ne 0 ]] ; then
  exit $?
fi

else # if [[ mode ]] 

# Add two dpdkvhost-user-client ports
export VHOST_SOCK_DIR=/usr/local/var/run/openvswitch
VHOST_USER_SOCKET_PATH_1=$VHOST_SOCK_DIR/vhostusersocket1.sock
VHOST_USER_SOCKET_PATH_2=$VHOST_SOCK_DIR/vhostusersocket2.sock

ovs-vsctl add-port br0 vhost-client-1 \
    -- set Interface vhost-client-1 type=dpdkvhostuserclient \
         ofport=3 \
         options:vhost-server-path=$VHOST_USER_SOCKET_PATH_1 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

ovs-vsctl add-port br0 vhost-client-2 \
    -- set Interface vhost-client-2 type=dpdkvhostuserclient \
         ofport=4 \
         options:vhost-server-path=$VHOST_USER_SOCKET_PATH_2 
if [[ $? -ne 0 ]] ; then
  exit $?
fi

fi # if [[ mode ]] 

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

ovs-ofctl dump-ports br0

ovs-ofctl show br0

read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

if [[ x$mode = x"hostuser" ]] ; then
source vm_hostuser.sh
else
source vm.sh
fi

