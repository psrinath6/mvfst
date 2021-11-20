#!/bin/bash

rm serverlogs.txt

for (( i=5000; i<=5045; i+=5 )); then
do
    echo "Starting server at port $i" >> serverlogs.txt
    ./_build/build/quic/tools/tperf/tperf -mode=server -host=10.10.1.1 -port=$i -num_server_worker=1 -gso=true -use_inplace_write=true -writes_per_loop=100 >> serverlogs.txt 2>&1 &
done
