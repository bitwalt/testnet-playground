#!/bin/bash
set -e
NETWORK="testnet" 

#TODO: Regtest 
PASS=$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 24 ; echo '')
USER="satoshi101"

echo 'Generating bitcoin.conf for network: ' $NETWORK
echo 'rpcuser: ' $USER
echo 'rpc_password: ' $PASS
RPC_PORT=8332
ZMQ_BLOCK_PORT=28332
ZMQ_TRANSACTION_PORT=28333

cat <<EOF > "bitcoin.conf"   
testnet=1
printtoconsole=1
server=1
rpcallowip=::/0
rpcuser=$USER
rpc_password=$PASS

# The address listening for ZMQ connections to deliver raw block notifications
zmqpubrawblock=tcp://0.0.0.0:$ZMQ_BLOCK_PORT
# The address listening for ZMQ connections to deliver raw transaction notifications
zmqpubrawtx=tcp://0.0.0.0:$ZMQ_TRANSACTION_PORT

[test]
rpcbind=0.0.0.0:$RPC_PORT

addnode=104.237.131.138
addnode=151.80.205.132
addnode=192.155.82.123
addnode=74.220.255.190
addnode=80.100.203.151
addnode=35.201.74.15

EOF
