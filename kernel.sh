#!/bin/bash -x

cd $KDIR
if [[ $? -ne 0 ]] ; then
  exit $?
fi

make mrproper
if [[ $? -ne 0 ]] ; then
  exit $?
fi

# sdk 19.01
#make mvebu_v8_lsp_defconfig

#sdk 19.06
make marvell_v8_sdk_defconfig
if [[ $? -ne 0 ]] ; then
  exit $?
fi

make -j8
if [[ $? -ne 0 ]] ; then
  exit $?
fi

make install INSTALL_PATH=$TFTPBOOT_DIR
if [[ $? -ne 0 ]] ; then
  exit $?
fi

make modules -j8
if [[ $? -ne 0 ]] ; then
  exit $?
fi

make modules_install INSTALL_MOD_PATH=$TFTPBOOT_DIR/usr
if [[ $? -ne 0 ]] ; then
  exit $?
fi
