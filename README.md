# Testnet Bitcoin-LN Playground 

The aim of this project is to speed-up a development environment over BP-LNP. 
Python binding and libraries are providid in order to develop over the LN protocol on a Layer-3 perspective.

Only **testnet** and **regtest** are supported.

The playground is based on a series of docker containers, orchestrated by a docker-compose file.

Tested on Raspberry Pi 4, Macbook Pro Intel Core, Macbook Air M1 

## Docker 
Install docker and docker-compose, skip if already installed 
```
chmod +x scripts/install_docker.sh
sudo ./scripts/install_docker.sh
```

## Modify environment variables
Define your specs in *config* file: 

 - Architecure: x86, ARM
 - Bitcoin Network: regtest
 - BitcoinCore version: 22.0
 - LND version: v0.14.3-beta
 
 Take a look to: [bitcoin-core-config-generator](https://jlopp.github.io/bitcoin-core-config-generator/) for more settings about *bitcoin.conf*.

## Running all
This command will generate config files (env, bitcoin.conf, lnd.conf) and docker-compose file based on the settings you provided. 
Then build docker images and run all containers. 
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
- [X]  Create multiple lnd nodes for regtest
- [X]  Connect 3 nodes on regtest to create a lightning network 
- [X]  Config file for fast configuration start-up -> gen new docker-compose.yml
- [ ]  Make a multi-hop payment in jupyter notebook
- [ ]  Tor on testnet
- [ ]  Connect testnet node with N new peers
- [ ]  Send sats on your testnet mobile wallet over LN 
- [ ]  Submarine swap on regtest using python 
- [ ]  Recurrent payment on regtest using python

## Donation 

Please consider to donate some satoshis if you like this project and encourage me to develop more.
    
Lightning Network Address:
`wallyyy@ln.tips`
    