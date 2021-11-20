#!/bin/bash
for (( i=0;i<$1;i++ )); do
         ./_build/build/quic/tools/tperf/tperf -mode=client -host=10.10.1.1 -use_inplace_write=true -gso=true -port=6660 -duration=60 -window=10000000000 &
done
