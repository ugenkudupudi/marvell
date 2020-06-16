#!/bin/bash -x

source ovs_cmn.sh

CPU_CORE=24

# OVS receive queue
ENABLE_N_RXQ=y

# default cpu mask
PMD_CPU_MASK=0x2

# OVS recieve queue descriptors
ENABLE_RXQ_DESC=n
RXQ_DESC_COUNT=64

ENABLE_SMC=n

restart_ovs

# (eth4 eth5 eth6 eth7)
#wan_pciaddr=(0002:06:00.0 0002:07:00.0 0002:08:00.0 0002:09:00.0)

# (eth4 and eth5)
wan_pciaddr=(0002:06:00.0 0002:07:00.0)

#wan_list=("wan0" "wan1" "wan2" "wan3")
wan_list=("wan0" "wan1")

ovs-vsctl add-br br0 -- set Bridge br0 datapath_type=netdev 

let i=0

# wan to pci address mapping
for wan in ${wan_list[@]}; do
	ovs-vsctl add-port br0 ${wan} -- set Interface ${wan} type=dpdk \
		options:dpdk-devargs=${wan_pciaddr[$i]}
	let "i=i+1"
done

#ovs-vsctl --no-wait set Open_vSwitch . other_config:dpdk-lcore-mask=0x23

# set pmd-cpu-mask based on CPU count
case $CPU_CORE  in
	24)
		# 1-23
		PMD_CPU_MASK==0xfffffe
		;;
	16)
		# 1-16
		PMD_CPU_MASK==0x1fffe
		;;
	8)
		PMD_CPU_MASK==0x1fe
		;;
	4)
		PMD_CPU_MASK==0x1e
		;;
	2)
		PMD_CPU_MASK=0x6
		;;
	1)
		PMD_CPU_MASK=0x2
		;;
	*)
		echo -n "Invalid CPU core" $CPU_CORE
		exit 1;
		;;
esac

# Set OVS+DPDK PMD CPU mask
ovs-vsctl --no-wait set Open_vSwitch . other_config:pmd-cpu-mask=$PMD_CPU_MASK

# Check if we need to set OVS receive queues; default is 1 if not set
if [[ $ENABLE_N_RXQ == 'y' ]] ;then
   let N_RXQ=$CPU_CORE/2
   echo "n rxq " $N_RXQ

   # OVS receive queues
   for wan in ${wan_list[@]}; do
      ovs-vsctl --no-wait set in ${wan} options:n_rxq=$N_RXQ
   done
fi

# ovs-vsctl --no-wait set in wan0 options:n_rxq=$N_RXQ

# Set OVS receive queue descriptors
if [[ $ENABLE_RXQ_DESC == 'y' ]] ;then
for wan in ${wan_list[@]}; do
ovs-vsctl --no-wait set interface ${wan} options:n_rxq_desc=$RXQ_DESC_COUNT
done
fi

#
# When traffic flow count is much larger than EMC size, it is generally beneficial to turn off EMC and turn on SMC
if [[ $ENABLE_SMC == 'y' ]] ;then
   ovs-vsctl --no-wait set Open_vSwitch . other_config:smc-enable=true
   for wan in ${wan_list[@]}; do
	ovs-vsctl --no-wait set interface ${wan} other_config:emc-enable=false
   done
fi

#for wan in ${wan_list[@]}; do
#ovs-vsctl --no-wait set in ${wan} options:mrg_rxbuf=off
#done

ovs-ofctl del-flows br0 
ovs-ofctl add-flow br0 in_port=wan0,action=output:wan1; 
ovs-ofctl add-flow br0 in_port=wan1,action=output:wan0; 
#ovs-ofctl add-flow br0 in_port=wan2,action=output:wan3; 
#ovs-ofctl add-flow br0 in_port=wan3,action=output:wan2; 

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

function restart_ovs()
{
	killall -9 ovs-vswitchd 
	killall -9 ovsdb-server

	rm -rf /var/log/ovs-vswitchd.log; 
	rm -rf /usr/local/var/run/openvswitch/ ; 
	rm -rf /usr/local/etc/openvswitch/ ; 

	mkdir -p /usr/local/var/run/openvswitch/ ; 
	mkdir -p /usr/local/etc/openvswitch/ ; 
	
	rm -f /tmp/conf.db ; 
	mkdir -p /usr/local/etc/openvswitch ; 
	mkdir -p /usr/local/var/run/openvswitch ; i
	ovsdb-tool create /usr/local/etc/openvswitch/conf.db /usr/local/share/openvswitch/vswitch.ovsschema 

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
}
