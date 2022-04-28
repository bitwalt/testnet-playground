# StackUP Bitcoin LN-Playground 

Bitcoin-LN **Testnet** Playground with high-level code and python api.

The aim of this project is to speed-up a development playground over bitcoin and LN.


## Docker 
Install docker and docker-compose, skip if already installed 
```
chmod +x install_docker.sh
./install_docker.sh
```

## Modify environment variables
Define your specs in .env: 

 - Architecure: x86, ARM
 - BitcoinCore version: 22.0
 - LND version: 1.x
 - Network: testnet
 - Blockchain directory: /mnt/bitcoin/blockchain
 - RPC user:password

If you want you can modify bitcoin.conf for more settings. Take a look to: [bitcoin-core-config-generator](https://jlopp.github.io/bitcoin-core-config-generator/)

## Running all
Run all with 

```
    bash start.sh  
```
Connect to bitcoin docker running
```
    make run-bitcoin
```

Connect to bitcoin docker running
```
    make run-bitcoin
```

### Running Bitcoin Core only
Read [bitcoin-testnet-box README.md](bitcoind/README.md) for more info/examples. 
```
    cd bitcoind
    make docker-build
    make docker-run
```

## Python Examples
[lnd-rest-api-example.ipynb](https://github.com/kadokko/example-lnd-rest-api/blob/master/notebook/lnd-rest-api-example.ipynb)

- Multi-hop Payment (Alice -> (Bob) -> Charlie)

### Repository inspired and/or based on: 
- https://github.com/getumbrel/umbrel
- https://github.com/kadokko/example-lnd-rest-api
- https://github.com/freewil/bitcoin-testnet-box
- https://github.com/lnbook/lnbook/tree/develop/code/docker
  
## TODO: 
- Create new bitcoin.conf and lnd.conf on start 
- REGTEST