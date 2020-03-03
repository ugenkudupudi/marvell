#!/bin/bash -x

#cd /usr/bin
#if [[ $? -ne 0 ]] ; then 
#	exit 1
#fi

if [[ -f Dockerfile ]] ; then
	rm Dockerfile
fi

cat <<EOT >> Dockerfile
FROM scratch
WORKDIR /root
MAINTAINER Ugendreshwar Kudupudi <ukudupudi@marvell.com>

ADD buildrootfs.tar.gz /

EOT
if [[ $? -ne 0 ]] ; then 
	exit 1
fi

docker build --rm -t ugenmarvell/buildroot:latest .
if [[ $? -ne 0 ]] ; then 
	exit 1
fi
