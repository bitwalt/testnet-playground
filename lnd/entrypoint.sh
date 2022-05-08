#!/bin/bash
set -Eeuo pipefail

# source /usr/local/bin/wait-for-bitcoind.sh

# echo Starting lnd...
# lnd --lnddir=/lnd --noseedbackup > /dev/null &

echo "Starting lnd in testnet mode..."

lnd --lnddir=.lnd --noseedbackup > /dev/null &

echo "Startup complete"
echo " "
echo "Create or load a new wallet.."

exec "$@"