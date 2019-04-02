#!/bin/bash -x

cd $BUILD_DIR_HOME
if [[ $? -ne 0 ]] ; then
  exit $?
fi

if [[ ! -f $OVS_DIR.tar.gz ]] ; then
wget $OVS_TARBALL_PATH
if [[ $? -ne 0 ]] ; then
  exit $?
fi
fi

if [[ ! -d $OVS_DIR ]] ; then
tar zxvf $OVS_DIR.tar.gz
if [[ $? -ne 0 ]] ; then
  exit $?
fi
fi

cd $OVS_DIR
if [[ $? -ne 0 ]] ; then
  exit $?
fi

#LIBS="-lmusdk " --prefix=$TFTPBOOT_DIR/usr/local
if [[ ! -f config.log ]] ; then
./configure --with-dpdk=$DPDK_HOME/build --host=aarch64-marvell-linux-gnu \
 --disable-ssl KARCH=arm64 \
 LDFLAGS="-L$BUILD_DIR_HOME/$MARVELL_TOOLCHAIN_HOME/lib64 \
 -L$TFTPBOOT_DIR/usr/local/lib \
" \
LIBS="-lmusdk "
if [[ $? -ne 0 ]] ; then
  exit $?
fi
fi

make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE -j8
if [[ $? -ne 0 ]] ; then
  exit $?
fi

#make install
make install DESTDIR=$TFTPBOOT_DIR
if [[ $? -ne 0 ]] ; then
  exit $?
fi
