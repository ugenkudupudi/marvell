#!/bin/bash -x

#cd /usr/bin
#if [[ $? -ne 0 ]] ; then 
#	exit 1
#fi

if [[ -f Dockerfile ]] ; then
	rm Dockerfile
fi

cat <<EOT >> Dockerfile
FROM ugenmarvell/buildroot:latest
MAINTAINER Ugendreshwar Kudupudi <ukudupudi@marvell.com>

WORKDIR /root

ADD dpdkrootfs.tar.gz /

VOLUME ["/var/run", "/var/run"]

EOT
if [[ $? -ne 0 ]] ; then 
	exit 1
fi

docker build --rm -t ugenmarvell/dpdk:latest .
if [[ $? -ne 0 ]] ; then 
	exit 1
fi
