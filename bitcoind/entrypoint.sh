#!/bin/bash
set -Eeuo pipefail

DATADIR=/home/bitcoin/
# Start bitcoind
echo "Starting bitcoind..."
bitcoind -datadir=$DATADIR -daemon 


# Wait for bitcoind startup
echo -n "Waiting for bitcoind to start"
until bitcoin-cli -datadir=$DATADIR -rpcwait getblockchaininfo  > /dev/null 2>&1
do
	echo -n "."
	sleep 1
done
echo
echo "Bitcoind started!"

# Executing CMD
exec "$@"