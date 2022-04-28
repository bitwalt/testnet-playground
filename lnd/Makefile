	
NETWORK=testnet 

docker-build:
	docker build \
	-t lnd_testnet \
	.

docker-run:
	docker run -it -d --rm --name lnd_testnet \
	-p 9735:9735 	\
	-p 18333:18333 \
	--user "$(id -u):$(id -g)" \
	-v $(PWD)/:.lnd \
	lnd_testnet

docker-attach:
	docker attach --detach-keys="ctrl-a" lnd_testnet

list-peers:
 	lncli --network=$(NETWORK) listpeers

genaddress:
	lncli --network=$(NETWORK) newaddress np2wkh 
