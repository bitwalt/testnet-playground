#!/bin/bash
set -Eeuo pipefail

# source /usr/local/bin/wait-for-bitcoind.sh

# echo Starting lnd...
# lnd --lnddir=/lnd --noseedbackup > /dev/null &

echo "Starting lnd in testnet mode..."

BITCOIN_RPC_USER=satoshi
BITCOIN_RPC_PASS=aZuiRvXwdl4lnXLYfWzJF3Pr
BITCOIN_IP=10.21.21.8
BITCOIN_ZMQ_RAWBLOCK_PORT=28332
BITCOIN_ZMQ_RAWTX_PORT=28333

lnd 

echo "Startup complete"
echo " "
echo "Create or load a new wallet.."

exec "$@"