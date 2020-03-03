#!/bin/bash -x

PATH=/usr/local/share/openvswitch/scripts:/usr/local/bin:/usr/local/sbin:$PATH

HOST_IP=127.0.0.1

dockerd --cluster-store=consul://127.0.0.1:8500 --cluster-advertise=$HOST_IP:0 
