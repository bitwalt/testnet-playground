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
Connect to the bitcoin container where you can run **bitcoin-cli**
```
    make run-bitcoin
```
Connect to the lnd container where you can run **lncli**
```
    make run-lnd
```

# Regtest 
```
#0. Run lnd node with regtest mode
lnd
#1. Create or load a wallet
lncli create
#2. Generate a new receiving address
lncli newaddress p2wkh
# 2. Send some bitcoin to the address
bitcoin-cli --datadir=. sendtoaddress bcrt1qmxk3jpe37a6dmlyevm48emn9m0nxyuk24edsg2  10 
```

### Running Bitcoin Core only
Read [bitcoin-testnet-box README.md](bitcoind/README.md) for more info/examples. 
```
    cd bitcoind
    make docker-build
    make docker-run
```

## Python Examples
- Multi-hop Payment (Alice -> (Bob) -> Charlie)
- Submarine Swap

### Repository inspired and/or based on: 
- [Umbrel](https://github.com/getumbrel/umbrel)
- [example-lnd-rest-api](https://github.com/kadokko/example-lnd-rest-api)
- [bitcoin-testnet-box](https://github.com/freewil/bitcoin-testnet-box)
- [MasteringTheLightningNetwork docker](https://github.com/lnbook/lnbook/tree/develop/code/docker)

## TODO: 
- [X] Create new bitcoin.conf and lnd.conf on start 
- [X] REGTEST
- [ ]  Create multiple lnd nodes for regtest
- [ ]  Connect 3 nodes on regtest to create a lightning network 
- [ ]  Config file for fast configuration start-up -> gen new docker-compose.yml
- [ ]  Make a multi-hop payment in jupyter notebook
- [ ]  Tor on testnet
- [ ]  Connect testnet node with N new peers
- [ ]  Send sats on your testnet mobile wallet over LN 
- [ ]  Submarine swap on regtest using python 
  