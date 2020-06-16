#!/bin/bash -x

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CPU_CORE=16

ENABLE_SMC=n

killall -9 ovs-vswitchd 
killall -9 ovsdb-server
rm -rf /var/log/ovs-vswitchd.log; rm -rf /usr/local/var/run/openvswitch/ ; rm -rf /usr/local/etc/openvswitch/ ; mkdir -p /usr/local/var/run/openvswitch/ ; mkdir -p /usr/local/etc/openvswitch/ ; rm -f /tmp/conf.db ; mkdir -p /usr/local/etc/openvswitch ; mkdir -p /usr/local/var/run/openvswitch ; ovsdb-tool create /usr/local/etc/openvswitch/conf.db /usr/local/share/openvswitch/vswitch.ovsschema 
 
ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock --remote=db:Open_vSwitch,Open_vSwitch,manager_options --pidfile --detach 

export DB_SOCK=/usr/local/var/run/openvswitch/db.sock 

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


if [[ $CPU_CORE == "16" ]]; then 
# 16 cores
ovs-vsctl --no-wait set Open_vSwitch . other_config:pmd-cpu-mask=0x7ffdc
elif [[ $CPU_CORE == "12" ]]; then 
# 12 cores
ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-lcore-mask=0x23
ovs-vsctl --no-wait set Open_vSwitch . other_config:pmd-cpu-mask=0x7ffdc
#ovs-vsctl --no-wait set Open_vSwitch . other_config:pmd-cpu-mask=0x7fdc
elif [[ $CPU_CORE == "8" ]]; then 
# 8 cores
ovs-vsctl --no-wait set Open_vSwitch . other_config:pmd-cpu-mask=0x7dc
else
echo "Please define CPU_CORE"
exit 1
fi

#eth4
wan0_pciaddr=0002:06:00.0
#eth5
wan1_pciaddr=0002:07:00.0
#eth6
wan2_pciaddr=0002:08:00.0
#eth7
wan3_pciaddr=0002:09:00.0

ovs-vsctl add-br br0 -- set Bridge br0 datapath_type=netdev 

ovs-vsctl add-port br0 wan0 -- set Interface wan0 type=dpdk \
    options:dpdk-devargs=$wan0_pciaddr

ovs-vsctl add-port br0 wan1 -- set Interface wan1 type=dpdk \
    options:dpdk-devargs=$wan1_pciaddr

ovs-vsctl add-port br0 wan2 -- set Interface wan2 type=dpdk \
    options:dpdk-devargs=$wan2_pciaddr

ovs-vsctl add-port br0 wan3 -- set Interface wan3 type=dpdk \
    options:dpdk-devargs=$wan3_pciaddr

if [[ $CPU_CORE == "16" ]]; then 
# 4 queues and 16 cores
ovs-vsctl --no-wait set in wan0 options:n_rxq=4 
ovs-vsctl --no-wait set in wan1 options:n_rxq=4
ovs-vsctl --no-wait set in wan2 options:n_rxq=4
ovs-vsctl --no-wait set in wan3 options:n_rxq=4
elif [[ $CPU_CORE == "12" ]]; then 
# 3 queues and 12 cores
ovs-vsctl --no-wait set in wan0 options:n_rxq=3 other_config:pmd-rxq-affinity=0:2,1:3,2:4
ovs-vsctl --no-wait set in wan1 options:n_rxq=3 other_config:pmd-rxq-affinity=0:6,1:7,2:8
ovs-vsctl --no-wait set in wan2 options:n_rxq=3 other_config:pmd-rxq-affinity=0:9,1:10,2:11
ovs-vsctl --no-wait set in wan3 options:n_rxq=3 other_config:pmd-rxq-affinity=0:12,1:13,2:14
elif [[ $CPU_CORE == "8" ]]; then 
# 2 queues and 8 cores
ovs-vsctl --no-wait set in wan0 options:n_rxq=2 other_config:pmd-rxq-affinity=0:2,1:3
ovs-vsctl --no-wait set in wan1 options:n_rxq=2 other_config:pmd-rxq-affinity=0:4,1:6
ovs-vsctl --no-wait set in wan2 options:n_rxq=2 other_config:pmd-rxq-affinity=0:7,1:8
ovs-vsctl --no-wait set in wan3 options:n_rxq=2 other_config:pmd-rxq-affinity=0:9,1:10
else
echo "Please define CPU_CORE"
exit 1
fi

ovs-vsctl --no-wait set interface wan0 options:n_rxq_desc=256
ovs-vsctl --no-wait set interface wan1 options:n_rxq_desc=256
ovs-vsctl --no-wait set interface wan2 options:n_rxq_desc=256
ovs-vsctl --no-wait set interface wan3 options:n_rxq_desc=256

#
# When traffic flow count is much larger than EMC size, it is generally beneficial to turn off EMC and turn on SMC
if [[ $ENABLE_SMC == 'y' ]] ;then
ovs-vsctl --no-wait set interface wan0 other_config:emc-enable=false
ovs-vsctl --no-wait set interface wan1 other_config:emc-enable=false
ovs-vsctl --no-wait set interface wan2 other_config:emc-enable=false
ovs-vsctl --no-wait set interface wan3 other_config:emc-enable=false
ovs-vsctl --no-wait set Open_vSwitch . other_config:smc-enable=true
fi

#ovs-vsctl --no-wait set in wan0 options:mrg_rxbuf=off
#ovs-vsctl --no-wait set in wan1 options:mrg_rxbuf=off
#ovs-vsctl --no-wait set in wan2 options:mrg_rxbuf=off
#ovs-vsctl --no-wait set in wan3 options:mrg_rxbuf=off

ovs-ofctl del-flows br0 
ovs-ofctl add-flow br0 in_port=wan0,action=output:wan1; 
ovs-ofctl add-flow br0 in_port=wan1,action=output:wan0; 
ovs-ofctl add-flow br0 in_port=wan2,action=output:wan3; 
ovs-ofctl add-flow br0 in_port=wan3,action=output:wan2; 

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
