#!/bin/bash -x

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

killall -9 ovs-vswitchd 
killall -9 ovsdb-server
rm -rf /var/log/ovs-vswitchd.log; rm -rf /usr/local/var/run/openvswitch/ ; rm -rf /usr/local/etc/openvswitch/ ; mkdir -p /usr/local/var/run/openvswitch/ ; mkdir -p /usr/local/etc/openvswitch/ ; rm -f /tmp/conf.db ; mkdir -p /usr/local/etc/openvswitch ; mkdir -p /usr/local/var/run/openvswitch ; ovsdb-tool create /usr/local/etc/openvswitch/conf.db /usr/local/share/openvswitch/vswitch.ovsschema 
 
ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock --remote=db:Open_vSwitch,Open_vSwitch,manager_options --pidfile --detach 

export DB_SOCK=/usr/local/var/run/openvswitch/db.sock 

#~/cn83xx/txcsr_83xx NIC_PF_CQM_CFG == 0x80

# This value should be set before setting dpdk-init=true. 
#ovs-vsctl --no-wait set Open_vSwitch . other_config:per-port-memory=true

ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-init=true

ovs-vsctl --no-wait init 
 
ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-socket-mem="8192"
#ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-socket-mem="16384"
#ovs-vsctl --no-wait set Open_vSwitch . other_config:pmd-auto-lb="true"

ovs-vswitchd unix:$DB_SOCK --pidfile --detach --log-file=/var/log/ovs-vswitchd.log 
if [[ $? -ne 0 ]]; then
	exit 1
fi
 
sleep 3

ovs-vsctl add-br br0 -- set Bridge br0 datapath_type=netdev 

ovs-vsctl add-port br0 wan0 -- set Interface wan0 type=dpdk \
    options:dpdk-devargs=0001:01:00.1 

ovs-vsctl add-port br0 vhostwan0 -- set Interface vhostwan0 type=dpdkvhostuser \
	options:dq-zero-copy=true

ovs-vsctl add-port br0 vhostlo0 -- set Interface vhostlo0 type=dpdkvhostuser \
	options:dq-zero-copy=true
ovs-vsctl add-port br0 vhostlo1 -- set Interface vhostlo1 type=dpdkvhostuser \
	options:dq-zero-copy=true

ovs-vsctl add-port br0 wan1 -- set Interface wan1 type=dpdk \
    options:dpdk-devargs=0001:01:00.2 

ovs-vsctl add-port br0 vhostwan1 -- set Interface vhostwan1 type=dpdkvhostuser \
	options:dq-zero-copy=true

ovs-ofctl del-flows br0
ovs-ofctl add-flow br0 in_port=wan0,action=output:vhostwan0; 
ovs-ofctl add-flow br0 in_port=vhostwan0,action=output:wan0; 

ovs-ofctl add-flow br0 in_port=vhostlo0,action=output:vhostlo1; 
ovs-ofctl add-flow br0 in_port=vhostlo1,action=output:vhostlo0; 

ovs-ofctl add-flow br0 in_port=wan1,action=output:vhostwan1; 
ovs-ofctl add-flow br0 in_port=vhostwan1,action=output:wan1; 

#ovs-appctl upcall/disable-megaflows
#ovs-appctl upcall/enable-megaflows

#ovs-appctl dpif-netdev/pmd-rxq-rebalance

ovs-ofctl dump-flows br0

#ovs-ofctl dump-ports br0
#ovs-appctl dpctl/show --statistics
#ovs-appctl dpif-netdev/pmd-stats-show

#ovs-appctl dpctl/dump-flows
#ovs-appctl dpctl/dump-flows| wc -l

#ovs-appctl dpif-netdev/pmd-rxq-show

#ovs-appctl dpctl/dump-flows system@ovs-system
#ovs-appctl dpctl/dump-flows netdev@ovs-netdev


#ovs-appctl dpif-netdev/pmd-perf-show [-nh] [-it iter-history-len] [-ms ms-history-len] [- pmd core] [dp]
#ovs-appctl dpif-netdev/pmd-rxq-rebalance [dp]
#ovs-appctl dpif-netdev/pmd-rxq-show [-pmd core] [dp]
#ovs-appctl dpif-netdev/pmd-stats-clear [-pmd core] [dp]
#ovs-appctl dpif-netdev/pmd-stats-show [-pmd core] [dp]
#ovs-appctl dpif/dump-dps
#ovs-appctl dpif/dump-flows         [-m] [--names | --no-names] bridge
#ovs-appctl dpif/set-dp-features    bridge
ovs-appctl dpif/show
#ovs-appctl dpif/show-dp-features   bridge


#watch -n 1 ovs-ofctl dump-ports br0
#~/cn83xx/txcsr_83xx NIC_QSX_CQX_CFG -d -a0 -b0
