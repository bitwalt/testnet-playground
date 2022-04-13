BITCOIND=bitcoind
BITCOINGUI=bitcoin-qt
BITCOINCLI=bitcoin-cli
T=-datadir=/home/bitcoin/testnet
BITCOIN_CORE_VERSION=22.0
ARCH=aarch64

start-testnet: 
	$(BITCOIND) $(T) -daemon
	
stop-testnet:
	$(BITCOINCLI) $(T) stop

createwallet:
	$(BITCOINCLI) $(T) createwallet wallet1
	
getinfo:
	$(BITCOINCLI) $(T) -getinfo

sendfrom:
	$(BITCOINCLI) $(T) sendtoaddress $(ADDRESS) $(AMOUNT)

address:
	$(BITCOINCLI) $(T) getnewaddress $(ACCOUNT)

stop:
	$(BITCOINCLI) $(T) stop
	
docker-build:
	docker build \
	-t btc_testnet \
	--build-arg BITCOIN_CORE_VERSION=$(BITCOIN_CORE_VERSION) \
	--build-arg ARCH=$(ARCH) .

docker-run:
	sudo docker run -it -d --rm --name btc_testnet \
	-p 18333:18333 	\
	-p 18332:18332 \
	--user "$(id -u):$(id -g)" \
	-v $(PWD)/:/home/bitcoin \
	btc_testnet

docker-attach:
	docker attach --detach-keys="ctrl-a" btc_testnet