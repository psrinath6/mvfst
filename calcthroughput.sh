#!/bin/bash

cat clientloggers.txt | grep -i overall | sed -nr 's/[a-zA-Z/]+//pg' | cut -d ":" -f5 > throughput.txt

file=throughput.txt
sum=0

if ! [ -e "$file" ] ; then
    echo "$0: $file does not exist" >&2
    exit 1
fi

numLines=$(wc -l clientloggers.txt | cut -d " " -f1)
activeProcs=$(ps aux | grep tperf | wc -l)
connErrors=$(cat clientloggers.txt | grep error | wc -l)

if [ $activeProcs -gt 1 ] ; then
        echo "The file is still being written to"
        exit 1
fi

withoutError=$(($1 - $connErrors))
echo "Successful connections: $withoutError"
awk '{ sum += $1 } END { print "Total Throughput for in Mb/s: ", sum }' "$file"
