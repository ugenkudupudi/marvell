#!/bin/bash -x

source $HOME/marvell/env.sh

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

OVS_FLAGS="--with-dpdk=$DPDK_HOME/build "
OVS_FLAGS+="--host=aarch64-marvell-linux-gnu "
OVS_FLAGS+="--disable-ssl "

OVS_LDFLAGS="-L$BUILD_DIR_HOME/$MARVELL_TOOLCHAIN_HOME/lib64 "
OVS_LDFLAGS+="-L$OVS_MOUNT_DISK_PATH/usr/local/lib "
OVS_LDFLAGS+="-L$OVS_MOUNT_DISK_PATH/usr/lib "

if [[ x$SOC_PLATFORM =~ ^xcn8[1,3]xx$ ]] ; then
echo
    OVS_LIBS="-ldbus-1 -lnl-3 -lnl-genl-3 -lpcap "
else
    OVS_LIBS="-lmusdk "
fi

if [[ ! -f config.log ]] ; then
    ./configure ${OVS_FLAGS} KARCH=${ARCH} LDFLAGS="${OVS_LDFLAGS}" LIBS="${OVS_LIBS}"
    if [[ $? -ne 0 ]] ; then
      exit $?
    fi
    patch -p1 < $TOOLS_HOME/ovs_dpdk.patch
    if [[ $? -ne 0 ]] ; then
      exit $?
    fi
fi

#vi config.h
make ARCH=$ARCH CROSS_COMPILE=$CROSS_COMPILE -j8
if [[ $? -ne 0 ]] ; then
  exit $?
fi

#make install
sudo make install DESTDIR=$OVS_MOUNT_DISK_PATH CROSS_COMPILE=$CROSS_COMPILE 
if [[ $? -ne 0 ]] ; then
echo $PATH
  exit $?
fi
