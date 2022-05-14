#!/bin/bash
# set -Eeuo pipefail

# DATADIR=/home/lnd/.lnd
BITCOIN_NETWORK="${NETWORK:-regtest}"

# source scripts/wait-for-bitcoind.sh
# echo Starting lnd...
# lnd --lnddir=/lnd --noseedbackup > /dev/null &
echo "Starting lnd in $BITCOIN_NETWORK mode..."

if [ "$BITCOIN_NETWORK" == "regtest" ]; then
    lnd --noseedbackup > /dev/null &
    sleep 5
    until lncli -n $BITCOIN_NETWORK getinfo > /dev/null 2>&1
    do
        sleep 1
    done
    echo "Startup complete"
    # Generate a new receiving address for LND wallet
    address=$(lncli -n $BITCOIN_NETWORK newaddress p2wkh | jq .address)
    echo "Funding address: $address"
    # echo "Funding lnd wallet"
    # source /usr/local/bin/fund-lnd.sh
fi 

exec tail -f /dev/null

