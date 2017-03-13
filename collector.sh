#!/bin/bash

CHAIN_PREFIX="ACC"
OUTPUT_DIR=/tmp
INTERVAL=5

function timestamp() {
	date +%s
}

function init() {
	ACC_CHAINS=$(iptables -L | grep "Chain $CHAIN_PREFIX" | awk '{print $2}' )
}

function chainEval() {
	for CHAIN in $ACC_CHAINS
	do
		DATA=
		for BYTES in $(iptables -n -v -x -L $CHAIN | tail -n +3 | awk '{print $2}')
		do
			DATA="$DATA,$BYTES"
		done
	
		echo $(timestamp):$CHAIN:$DATA >> $OUTPUT_DIR/"$CHAIN"_$(date +%F)
	done
}

init
echo "press CTL-C to abort"

while true
do
	chainEval
	sleep $INTERVAL
done
