#!/bin/bash
set -Eeuo pipefail

DATADIR=/home/bitcoin/

export address=`cat $DATADIR/keys/demo_address.txt`
echo "================================================"
echo "Balance:" `bitcoin-cli -datadir=$DATADIR getbalance`
echo "================================================"
echo "Mining 101 blocks to unlock some bitcoin"
bitcoin-cli -datadir=$DATADIR generatetoaddress 101 $address
echo "Mining 6 blocks every 10 seconds"
while echo "Balance:" `bitcoin-cli -datadir=$DATADIR getbalance`;
do
	bitcoin-cli -datadir=$DATADIR generatetoaddress 6 $address; \
	sleep 10; \

done

# If loop is interrupted, stop bitcoind
bitcoin-cli -datadir=$DATADIR stop
