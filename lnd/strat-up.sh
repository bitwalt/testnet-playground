

lnd --bitcoin.active --bitcoin.testnet --debuglevel=debug \
       --bitcoin.node=bitcoind \
       --bitcoind.rpcuser=REPLACEME \
       --bitcoind.rpcpass=REPLACEME \
       --bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332 \
       --bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333 \
       --externalip=X.X.X.X