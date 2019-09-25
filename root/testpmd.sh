#!/bin/bash -x

testpmd -w 0001:01:00.1 -w 0001:01:00.2 -c f -- \
  --burst=256 --txd=2048 --rxd=1024 --rxq=1 --txq=1 --nb-cores=1 \
  --coremask 2 -a --forward-mode=io
