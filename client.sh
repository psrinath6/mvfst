#!/bin/bash

rm clientloggers.txt
rm throughput.txt
for (( i=0;i<200;i++ )); do
        echo "Starting client $i" >> clientloggers.txt
         ./_build/build/quic/tools/tperf/tperf -mode=client -host=10.10.1.1 -use_inplace_write=true -gso=true -port=$1 -duration=60 -window=10000000000 -client_transport_timer_resolution_ms=6000 >> clientloggers.txt 2>&1 &
done
