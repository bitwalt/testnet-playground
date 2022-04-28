#!/bin/bash
set -Eeuo pipefail

BITCOIN_RPC_USER=satoshi
BITCOIN_RPC_PASS=aZuiRvXwdl4lnXLYfWzJF3Pr
BITCOIN_IP=10.21.21.8
BITCOIN_RPC_PORT=18332 # 18332 for testnet and 8332 for mainnet


echo "Waiting for bitcoind to start..."
until curl --silent --user $BITCOIN_RPC_USER:$BITCOIN_RPC_PASS --data-binary '{"jsonrpc": "1.0", "id": "lnd-node", "method": "getblockchaininfo", "params": []}' -H 'content-type: text/plain;' http://$BITCOIN_IP:$BITCOIN_RPC_PASS/ | jq -e ".result.blocks > 0" > /dev/null 2>&1
do
	echo -n "."
	sleep 1
done