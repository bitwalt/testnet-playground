# StackUP Bitcoin LN-Playground 
Play with high-level python api over Bitcoin and Lightning Network on Testnet or Regtest.

The aim of this project is to speed-up development playgrounds over bitcoin and LN

StackUP Playground
 |
 LND
 |
 Bitcoin-core
 |
 TCP
 | 
 IP 

0. Define your specs in .env: 
 - Architecure: x86, ARM
 - BitcoinCore version: 22.0
 - LND version: 1.x

1. Install docker, docker-compose
    sudo bash install_docker.sh

2. Define your networks (?): 
- 2 bitcoin core 
- 8 lnd node
- 3 c-lightning

3. Run all ! 
    run docker-compose with bitcoind, lnd, playground (jupyter-notebook, gRPC, ...)

4. Examples
(https://github.com/kadokko/example-lnd-rest-api/blob/master/notebook/lnd-rest-api-example.ipynb)
- Multi-hop Payment (Alice -> (Bob) -> Charlie)
