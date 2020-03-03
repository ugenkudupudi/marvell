#!/bin/bash -x

# move to the build/work directory
cd $BUILD_DIR_HOME
if [[ $? -ne 0 ]] ; then
  exit $?
fi

######################### TOOLCHAIN START ###################################
# unpack the gcc toolchain for arm64
if [[ ! -d toolchain ]] ; then
   tar xvf $TOOLCHAIN_TARBALL
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
######################### TOOLCHAIN END ###################################

# Extract sources of Marvell SW components (u-boot, TF-A, SDK, etc)
if [[ ! -d $BASE_SRC ]] ; then
    tar xvf $BASE_SRC_TARBALL
    if [[ $? -ne 0 ]] ; then
       exit $?
    fi
fi

# Extract buildroot sources release 2018.11
if [[ ! -d $SRC_BUILDROOT ]] ; then
    tar xvf $SRC_BUILDROOT_TARBALL
    if [[ $? -ne 0 ]] ; then
       exit $?
    fi
fi

# Extract Marvell Buildroot external packages (board configurations, SW components makefiles, DTS files, etc.)
if [[ ! -d $SRC_BUILDROOT_EXT ]] ; then
    tar xvf $SRC_BUILDROOT_EXT_TARBALL
    if [[ $? -ne 0 ]] ; then
       exit $?
    fi
fi


# Extract MUSDK


# Extract DPDK



