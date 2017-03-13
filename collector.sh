#!/bin/bash

CHAIN_PREFIX="ACC"
OUTPUT_DIR=/tmp
INTERVAL=5
IFS=$'\n';

function timestamp() {
	date +%s
}

function debug() {
	if [ ! -z $DEBUG ]
	then
		echo -e $1
	fi
}

function chainEval() {
	ACC_CHAINS=$(iptables -L | grep "Chain $CHAIN_PREFIX" | awk '{print $2}' )

	for CHAIN in $ACC_CHAINS
	do
		debug $CHAIN
		for RULE in $(iptables -n -v -x -L $CHAIN | tail -n +3)
		do
			DATA=$(echo $RULE | awk '{print $2}')
			DATA=$[$DATA*8]
			SRC_DST=$(echo $RULE | awk '{print $8"_"$9}' | sed 's/\//-/g')
			debug "$SRC_DST $DATA"
			echo "$(timestamp),$DATA" >> $OUTPUT_DIR/"$CHAIN"_$(date +%F)_"$SRC_DST"
		done
	
		iptables -Z $CHAIN
	done
}

echo "press CTL-C to abort"

while true
do
	chainEval
	sleep $INTERVAL
done
