#!/bin/bash -x

echo "Build DPDK... "

cd $DPDK_HOME
if [[ $? -ne 0 ]] ; then
  exit $?
fi

if [[ ! -f config/.config ]]; then
   make config T=arm64-armada-linuxapp-gcc
   if [[ $? -ne 0 ]] ; then
     exit $?
   fi
fi

make -j8
if [[ $? -ne 0 ]] ; then
  exit $?
fi

rm arm64-armada-linuxapp-gcc
ln -s build arm64-armada-linuxapp-gcc
if [[ $? -ne 0 ]] ; then
  exit $?
fi

make -j8 examples T=arm64-armada-linuxapp-gcc
if [[ $? -ne 0 ]] ; then
  exit $?
fi

make install DESTDIR=$TFTPBOOT_DIR
if [[ $? -ne 0 ]] ; then
  exit $?
fi
