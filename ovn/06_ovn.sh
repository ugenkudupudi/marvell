#!/bin/bash -x

PATH=/usr/local/share/openvswitch/scripts:/usr/local/bin:/usr/local/sbin:$PATH

CENTRAL_IP=127.0.0.1
LOCAL_IP=127.0.0.1
ENCAP_TYPE=gre

function set_ovs_uuidgen() {

	if [[ ! -d /etc/openvswitch ]] ; then
		mkdir -p /etc/openvswitch
	fi 
	
	id_file=/etc/openvswitch/system-id.conf 
	test -e $id_file || uuidgen > $id_file
       	ovs-vsctl set Open_vSwitch . external_ids:system-id=$(cat $id_file)
}

# resolves sock error
if [ ! -d /usr/local/var/log/openvswitch ] ; then
	mkdir /usr/local/var/log/openvswitch
fi

# each Open vSwitch instance in an OVN deployment needs a 
# unique, persistent identifier, called the system-id
set_ovs_uuidgen

ovn-ctl restart_northd
if [[ $? -ne 0 ]]; then
	exit $?
fi

ovn-nbctl set-connection ptcp:6641
if [[ $? -ne 0 ]]; then
	exit $?
fi

ovn-sbctl set-connection ptcp:6642
if [[ $? -ne 0 ]]; then
	exit $?
fi

ovs-vsctl set Open_vSwitch . \
	    external_ids:ovn-remote="tcp:$CENTRAL_IP:6642" \
	        external_ids:ovn-nb="tcp:$CENTRAL_IP:6641" \
		    external_ids:ovn-encap-ip=$LOCAL_IP \
		        external_ids:ovn-encap-type="$ENCAP_TYPE"
if [[ $? -ne 0 ]]; then
	exit $?
fi


ovn-ctl restart_controller
if [[ $? -ne 0 ]]; then
	exit $?
fi

ovn-docker-overlay-driver --detach
if [[ $? -ne 0 ]]; then
	exit $?
fi

docker network create -d openvswitch --subnet=192.168.22.0/24 ovs
if [[ $? -ne 0 ]]; then
	exit $?
fi

docker network ls
