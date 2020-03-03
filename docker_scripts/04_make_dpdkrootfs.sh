#!/bin/sh -x

tar zcvf dpdkrootfs.tar.gz \
	/bin/dpdk-eventdev_pipeline \
       	/bin/dpdk-l3fwd \
	/bin/dpdk-test \
       	/bin/dpdk-ipsec-secgw \
	/bin/dpdk-pdump \
       	/bin/dpdk-test-compress-perf \
	/bin/dpdk-l2fwd \
       	/bin/dpdk-pmdinfo \
	/bin/dpdk-test-crypto-perf \
	/bin/dpdk-l2fwd-event \
	/bin/dpdk-procinfo \
       	/bin/dpdk-test-eventdev \
       	/lib/libpcap.so  /lib/libpcap.so.1  /lib/libpcap.so.1.8.1 \
	/lib/libnl-3.so  /lib/libnl-3.so.200  /lib/libnl-3.so.200.26.0 \
	/lib/libnl-genl-3.so  /lib/libnl-genl-3.so.200  /lib/libnl-genl-3.so.200.26.0 \
	/lib/libdbus-1.so  /lib/libdbus-1.so.3  /lib/libdbus-1.so.3.19.8 \
	/lib64/libpcap.so  /lib64/libpcap.so.1  /lib64/libpcap.so.1.8.1 \
	/lib64/libnl-3.so  /lib64/libnl-3.so.200  /lib64/libnl-3.so.200.26.0 \
	/lib64/libnl-genl-3.so  /lib64/libnl-genl-3.so.200  /lib64/libnl-genl-3.so.200.26.0 \
	/lib64/libdbus-1.so  /lib64/libdbus-1.so.3  /lib64/libdbus-1.so.3.19.8 \
