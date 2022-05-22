#!/bin/bash
set -Eeuo pipefail

BITCOIN_NETWORK="${NETWORK:-regtest}"

# LOAD ENV VARS
CONFIG_FILE="/home/lnd/.env"
[[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"

echo "Starting lnd in $BITCOIN_NETWORK mode..."

echo "Waiting for bitcoind to start..."
until curl --silent --user $BITCOIN_RPC_USER:$BITCOIN_RPC_PASS --data-binary '{"jsonrpc": "1.0", "id": "lnd-node", "method": "getblockchaininfo", "params": []}' -H 'content-type: text/plain;' http://$BITCOIN_IP:$BITCOIN_RPC_PORT/ | jq -e ".result.blocks > 0" > /dev/null 2>&1
do
	echo -n "."
	sleep 1
done
echo "Startup complete"

if [ "$BITCOIN_NETWORK" == "regtest" ]; then
    echo "Running LND with IP: $IP"
    lnd --tlsextraip=$IP --noseedbackup > /dev/null &
    
    until lncli -n $BITCOIN_NETWORK getinfo > /dev/null 2>&1
    do
        sleep 1
    done
    # Generate a new receiving address for LND wallet
    address=$(lncli -n $BITCOIN_NETWORK newaddress p2wkh | jq .address)
    echo "Funding address: $address"
    echo "Copying macaroon and TLS certificate to share directory..."
    cp -p /home/lnd/.lnd/data/chain/bitcoin/$BITCOIN_NETWORK/admin.macaroon /home/lnd/share/
    cp -p /home/lnd/.lnd/tls.cert /home/lnd/share/
    echo "Done!"
fi 

exec tail -f /dev/null

