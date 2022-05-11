#!/bin/bash
set -Eeuo pipefail

DATADIR=/home/lnd/.lnd
BITCOIN_NETWORK="${NETWORK:-regtest}"

# source scripts/wait-for-bitcoind.sh
# echo Starting lnd...
# lnd --lnddir=/lnd --noseedbackup > /dev/null &
echo "Starting lnd in $BITCOIN_NETWORK mode..."

if [ "$BITCOIN_NETWORK" == "regtest" ]; then
    lnd --lnddir=$DATADIR --noseedbackup > /dev/null &

    until lncli --lnddir=$DATADIR -n $BITCOIN_NETWORK getinfo > /dev/null 2>&1
    do
        sleep 1
    done
    echo "Startup complete"
    # echo "Funding lnd wallet"
    # source /usr/local/bin/fund-lnd.sh
    # exec "$@"
fi 
echo " "
exec "$@"
