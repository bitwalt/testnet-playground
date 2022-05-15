#!/bin/bash
set -Eeuo pipefail

BITCOIN_NETWORK="${NETWORK:-regtest}"

echo "Starting lnd in $BITCOIN_NETWORK mode..."

# echo "Waiting for bitcoind to start..."
# until curl --silent --user regtest:regtest --data-binary '{"jsonrpc": "1.0", "id": "lnd-node", "method": "getblockchaininfo", "params": []}' -H 'content-type: text/plain;' http://bitcoind:18443/ | jq -e ".result.blocks > 0" > /dev/null 2>&1
# do
# 	echo -n "."
# 	sleep 1
# done
sleep 5

if [ "$BITCOIN_NETWORK" == "regtest" ]; then
    lnd --noseedbackup > /dev/null &
    
    until lncli -n $BITCOIN_NETWORK getinfo > /dev/null 2>&1
    do
        sleep 1
    done
    echo "Startup complete"
    # Generate a new receiving address for LND wallet
    address=$(lncli -n $BITCOIN_NETWORK newaddress p2wkh | jq .address)
    echo "Funding address: $address"
    echo "Copying macaroon and TLS certificate to share directory..."
    cp -p /home/lnd/.lnd/data/chain/bitcoin/$BITCOIN_NETWORK/admin.macaroon /home/lnd/share/
    cp -p /home/lnd/.lnd/tls.cert /home/lnd/share/
    echo "Done!"
fi 

exec tail -f /dev/null

