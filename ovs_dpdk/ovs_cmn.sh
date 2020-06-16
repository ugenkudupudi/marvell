#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

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
