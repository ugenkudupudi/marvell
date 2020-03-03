#!/bin/bash -x

# move to the build/work directory
cd $BUILD_DIR_HOME/buildroot-external-marvell
if [[ $? -ne 0 ]] ; then
  exit $?
fi

if [[ x$RELEASE_ID != x && x$SOC_PLATFORM != x ]]; then
    ./scripts/ci/compile.sh -r $RELEASE_ID $SOC_PLATFORM
else
   echo "Define RELEASE_ID and SOC_PLATFORM in env.sh"
   exit 1;
fi
