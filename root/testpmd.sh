#!/bin/bash

/usr/local/bin/testpmd -- \
--burst=256 --txd=2048 --rxd=1024 --rxq=1 --txq=1 --nb-cores=1 \
--coremask 2 -a --forward-mode=io

