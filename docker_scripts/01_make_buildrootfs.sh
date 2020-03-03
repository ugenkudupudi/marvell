#!/bin/sh -x

tar zcvf buildrootfs.tar.gz \
	/bin/sh \
	/bin/bash \
	/bin/ls \
	/bin/pwd \
	/bin/mkdir \
	/bin/rmdir \
	/bin/rm \
	/bin/iperf3 \
	/bin/iperf \
	/lib/libc.so.6 /lib/libc-2.27.so \
	/lib/libm.so.6 /lib/libm-2.27.so \
        /lib/*iperf* \
	/lib/libdl.so.2 /lib/libdl-2.27.so \
	/lib/libcrypto.so  /lib/libcrypto.so.1.0.0 \
	/lib/libssl.so  /lib/libssl.so.1.0.0 \
	/lib/librt-2.27.so  /lib/librt.so.1 \
	/lib/libcap.so  /lib/libcap.so.2  /lib/libcap.so.2.25 \
	/lib/libpthread-2.27.so  /lib/libpthread.so.0 \
	/lib/libgmp.so  /lib/libgmp.so.10  /lib/libgmp.so.10.3.2 \
	/lib/ld-2.27.so  /lib/ld-linux-aarch64.so.1 \
	/lib/libreadline.so  /lib/libreadline.so.7  /lib/libreadline.so.7.0 \
	/lib/libncurses.so  /lib/libncurses.so.6  /lib/libncurses.so.6.1 \
	/lib/libhistory.so  /lib/libhistory.so.7  /lib/libhistory.so.7.0 \
	/lib/libstdc++.so.6  /lib/libstdc++.so.6.0.24  /lib/libstdc++.so.6.0.24-gdb.py \
	/lib/libgcc_s.so.1 \
	/lib64/libc.so.6 /lib64/libc-2.27.so \
	/lib64/libm.so.6 /lib64/libm-2.27.so \
        /lib64/*iperf* \
	/lib64/libdl.so.2 /lib64/libdl-2.27.so \
	/lib64/libcrypto.so  /lib64/libcrypto.so.1.0.0 \
	/lib64/libssl.so  /lib64/libssl.so.1.0.0 \
	/lib64/librt-2.27.so  /lib64/librt.so.1 \
	/lib64/libcap.so  /lib64/libcap.so.2  /lib64/libcap.so.2.25 \
	/lib64/libpthread-2.27.so  /lib64/libpthread.so.0 \
	/lib64/libgmp.so  /lib64/libgmp.so.10  /lib64/libgmp.so.10.3.2 \
	/lib64/ld-2.27.so  /lib64/ld-linux-aarch64.so.1 \
	/lib64/libreadline.so  /lib64/libreadline.so.7  /lib64/libreadline.so.7.0 \
	/lib64/libncurses.so  /lib64/libncurses.so.6  /lib64/libncurses.so.6.1 \
	/lib64/libhistory.so  /lib64/libhistory.so.7  /lib64/libhistory.so.7.0 \
	/lib64/libstdc++.so.6  /lib64/libstdc++.so.6.0.24  /lib64/libstdc++.so.6.0.24-gdb.py \
	/lib64/libgcc_s.so.1 
