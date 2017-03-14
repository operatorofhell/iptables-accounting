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
		echo -e $*
	fi
}

function chainEval() {
	ACC_CHAINS=$(iptables -L | grep "Chain $CHAIN_PREFIX" | awk '{print $2}' )

	for CHAIN in $ACC_CHAINS
	do
		debug $CHAIN
		for (( i=1; 1; i++))
		do
			LINE=$(iptables -n -v -x -L $CHAIN $i)

			if [ -z "$LINE" ]
			then
				break
			fi

			DATA=$(echo $LINE | awk '{print $2}')
			DATA=$[$DATA*8]
			SRC_DST=$(echo $LINE | awk '{print $8"_"$9}' | sed 's/\//-/g')

			debug writing: $(timestamp),$DATA to:  $OUTPUT_DIR/"$CHAIN"_$(date +%F)_"$SRC_DST"
			echo "$(timestamp),$DATA" >> $OUTPUT_DIR/"$CHAIN"_$(date +%F)_"$SRC_DST"

			iptables -Z $CHAIN $i
		done
	done
}

echo "press CTL-C to abort"

while true
do
	chainEval
	sleep $INTERVAL
done
