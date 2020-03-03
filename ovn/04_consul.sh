#!/bin/bash -x

PATH=/usr/local/share/openvswitch/scripts:/usr/local/bin:/usr/local/sbin:$PATH

HOST_IP=127.0.0.1

if [[ ! -d /tmp/consul ]]; then
	mkdir -p /tmp/consul
fi

consul agent -ui -server -data-dir /tmp/consul -advertise 127.0.0.1 -bootstrap-expect 1 

