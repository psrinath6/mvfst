#!/bin/bash
for (( i=0;i<$1;i++ )); do
         ./_build/build/quic/tools/tperf/tperf -mode=client -host=10.10.1.1 -gso=true -port=6660 -duration=600 -window=5000000 &
done
