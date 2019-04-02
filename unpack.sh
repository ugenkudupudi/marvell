#!/bin/bash -x

# create the build directory
cd $BUILD_DIR_HOME
if [[ $? -ne 0 ]] ; then
  exit $?
fi

# unpack the gcc toolchain for arm64
if [[ ! -d toolchain ]] ; then
tar xvf $HOME/$TOOLCHAIN_TARBALL.tar.bz2
if [[ $? -ne 0 ]] ; then
  exit $?
fi
fi

if [[ ! -d $MARVELL_TOOLCHAIN_HOME ]] ; then
tar xvf toolchain/$MARVELL_TOOLCHAIN_HOME.tar.bz2
if [[ $? -ne 0 ]] ; then
  exit $?
fi
fi

# unpack the linux kernel source 
if [[ ! -d $BASE_SOURCE-$RELEASE_ID ]] ; then
tar xvf $BASE_SOURCE-$RELEASE_ID.tar.bz2
if [[ $? -ne 0 ]] ; then
  exit $?
fi
fi

if [[ ! -d $KDIR ]] ; then
tar xvf $BASE_SOURCE-$RELEASE_ID/linux/$SOURCES_LINUX-$RELEASE_ID.tar.bz2
if [[ $? -ne 0 ]] ; then
  exit $?
fi
fi

# unpack the wusdk and dpdk packages 
if [[ ! -d $DATAPLANE_SOURCE-$RELEASE_ID ]] ; then
tar xvf $DATAPLANE_SOURCE-$RELEASE_ID.tar.bz2
if [[ $? -ne 0 ]] ; then
  exit $?
fi
fi

if [[ ! -d $DPDK_HOME ]] ; then
tar xvf $DATAPLANE_SOURCE-$RELEASE_ID/dpdk/$SOURCES_DPDK-$RELEASE_ID.tar.bz2
if [[ $? -ne 0 ]] ; then
  exit $?
fi
fi

if [[ ! -d $LIBMUSDK_HOME_PATH ]] ; then
tar xvf $DATAPLANE_SOURCE-$RELEASE_ID/musdk-marvell/$SOURCES_MUSDK-$RELEASE_ID.tar.bz2
if [[ $? -ne 0 ]] ; then
  exit $?
fi #end of tar xvf

# patch the linux kernel with musdk patches
source patch.sh
if [[ $? -ne 0 ]] ; then
  exit $?
fi #end of patch.sh

fi # end of -d

