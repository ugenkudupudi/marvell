#!/bin/bash -x

export APP=iperf

#docker pull ugenmarvell/$APP
#if [[ $? -ne 0 ]]; then
#	exit $?
#fi

docker run  -it --rm --name=$APP \
	ugenmarvell/$APP -s
if [[ $? -ne 0 ]]; then
	exit $?
fi

