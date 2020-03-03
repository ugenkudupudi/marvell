#!/bin/bash -x

docker login
if [[ $? -ne 0 ]] ; then 
	exit 1
fi

docker push ugenmarvell/buildroot
if [[ $? -ne 0 ]] ; then 
	exit 1
fi

