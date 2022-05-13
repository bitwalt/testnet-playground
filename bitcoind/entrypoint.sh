#!/bin/bash
set -Eeuo pipefail

DATADIR=/home/bitcoin
BITCOIN_NETWORK="${NETWORK:-regtest}"
# Start bitcoind
echo "Starting bitcoind on $BITCOIN_NETWORK..."
bitcoind -daemon 

# Wait for bitcoind startup
echo -n "Waiting for bitcoind to start"
echo -n .
until bitcoin-cli -rpcwait getblockchaininfo  > /dev/null 2>&1
do
	echo -n "."
	sleep 1
done
echo
echo "Bitcoind started!"


if [ "$BITCOIN_NETWORK" == "regtest" ]; then
	# Load private key into wallet
	export address=`cat $DATADIR/keys/demo_address.txt`
	export privkey=`cat $DATADIR/keys/demo_privkey.txt`

	# If restarting the wallet already exists, so don't fail if it does,
	# just load the existing wallet:
	bitcoin-cli createwallet regtest > /dev/null || bitcoin-cli loadwallet regtest > /dev/null
	bitcoin-cli importprivkey $privkey > /dev/null || true

	echo "================================================"
	echo "Imported demo private key"
	echo "Bitcoin address: " ${address}
	echo "Private key: " ${privkey}
	echo "================================================"
	echo "Wallet loaded!"
	
	# Start mining
	echo "Starting mining..."
	source /mine.sh
	# while true; do
	# 	sleep 10 ; 
	# done

fi


# Executing CMD
exec "$@"