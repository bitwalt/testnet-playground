#!/bin/bash
set -Eeuo pipefail

DATADIR=/home/bitcoin/

export address=`cat $DATADIR/keys/demo_address.txt`
echo "Address loaded: " ${address}
echo "================================================"
echo "Mining 101 blocks to unlock some bitcoin"
bitcoin-cli generatetoaddress 101 $address > /dev/null ; 
echo "Balance:" `bitcoin-cli getbalance`

echo "Mining 6 blocks every 10 seconds..."
while true;
do
	bitcoin-cli generatetoaddress 6 $address > /dev/null ; \
	sleep 10; \
done

# If loop is interrupted, stop bitcoind
bitcoin-cli stop
