#!/bin/sh -x

sysctl vm.nr_hugepages=512
if [[ $? -ne 0 ]] ; then
        exit $?
fi

mkdir -p /dev/hugepages
if [[ $? -ne 0 ]] ; then
        exit $?
fi

mount -t hugetlbfs hugetlbfs /dev/hugepages  # only if not already mounted
if [[ $? -ne 0 ]] ; then
        exit $?
fi

insmod /root/lib/modules/4.4.0-143-generic/extra/dpdk/igb_uio.ko
if [[ $? -ne 0 ]] ; then
        exit $?
fi

/usr/local/share/dpdk/usertools/dpdk-devbind.py --status
if [[ $? -ne 0 ]] ; then
        exit $?
fi

/usr/local/share/dpdk/usertools/dpdk-devbind.py -b igb_uio 00:01.0 00:02.0
if [[ $? -ne 0 ]] ; then
        exit $?
fi

/usr/local/share/dpdk/usertools/dpdk-devbind.py --status

source testpmd.sh
if [[ $? -ne 0 ]] ; then
        exit $?
fi
