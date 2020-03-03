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
WORKDIR /root
MAINTAINER Ugendreshwar Kudupudi <ukudupudi@marvell.com>

# Expose the default iperf server port
EXPOSE 5001

VOLUME ["/tmp", "/tmp" ]

# entrypoint allows you to pass your arguments to the container at runtime
# very similar to a binary you would run. For example, in the following
# docker run -it <IMAGE> --help' is like running 'iperf --help'
ENTRYPOINT ["iperf"]
EOT
if [[ $? -ne 0 ]] ; then 
	exit 1
fi

docker build --rm -t ugenmarvell/iperf:latest .
if [[ $? -ne 0 ]] ; then 
	exit 1
fi
