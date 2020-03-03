#!/bin/bash

APP=iperf

#docker pull ugenmarvell/$APP
#if [[ $? -ne 0 ]]; then
#	exit $?
#fi

ip_address=$(docker inspect --format "{{ .NetworkSettings.IPAddress }}" $APP)

if [[ x$ip_address = "x" ]] ; then
echo "Error: Unable to get IP address" 
else
echo The IP Address is $ip_address

docker run  -it --rm \
	ugenmarvell/$APP -c $ip_address
if [[ $? -ne 0 ]]; then
	exit $?
fi
fi # endif ne x
