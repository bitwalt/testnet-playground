BITCOIND=bitcoind
BITCOINGUI=bitcoin-qt
BITCOINCLI=bitcoin-cli
T=-datadir=/home/bitcoin/
BITCOIN_CORE_VERSION=22.0
ARCH=aarch64
ADDRESS=bcrt1q3636r9ax6gpsqctc0k6n5v8cprc05ntz8cr5uz

start: 
	$(BITCOIND) $(T) -daemon

stop:
	$(BITCOINCLI) $(T) stop
		
createwallet:
	$(BITCOINCLI) $(T) createwallet wallet1
	
loadwallet:
	$(BITCOINCLI) $(T) loadwallet wallet1
	
getinfo:
	$(BITCOINCLI) $(T) -getinfo

sendfrom:
	$(BITCOINCLI) $(T) sendtoaddress $(ADDRESS) $(AMOUNT)

genaddress:
	$(BITCOINCLI) $(T) getnewaddress $(ACCOUNT)

mine:
	$(BITCOINCLI) $(T) generatetoaddress 101 $(ADDRESS)

docker-build:
	docker build \
	-t btc_testnet \
	--build-arg BITCOIN_CORE_VERSION=$(BITCOIN_CORE_VERSION) \
	--build-arg ARCH=$(ARCH) .

docker-run:
	docker run -it -d --rm --name btc_testnet \
	-p 18333:18333 	\
	-p 18332:18332 \
	--user "$(id -u):$(id -g)" \
	-v $(PWD)/:/home/bitcoin \
	btc_testnet

docker-attach:
	docker attach --detach-keys="ctrl-a" btc_testnet