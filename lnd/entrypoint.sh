#!/bin/bash
set -Eeuo pipefail

source /usr/local/bin/wait-for-bitcoind.sh

# echo Starting lnd...
# lnd --lnddir=/lnd --noseedbackup > /dev/null &

echo "Starting lnd in testnet mode..."

lnd --bitcoin.active --bitcoin.testnet --debuglevel=debug \
       --bitcoin.node=bitcoind \
       --bitcoind.rpcuser=satoshi \
       --bitcoind.rpcpass=aZuiRvXwdl4lnXLYfWzJF3Pr \
       --bitcoind.zmqpubrawblock=tcp://10.21.21.0:28332 \
       --bitcoind.zmqpubrawtx=tcp://10.21.21.0:28333 \
    #    --externalip=X.X.X.X

until lncli  -n testnet getinfo > /dev/null 2>&1
do
	sleep 1
done
echo "Startup complete"

exec "$@"