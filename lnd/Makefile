	
NETWORK=regtest 

listpeers:
	lncli -n=$(NETWORK) listpeers

genaddress:
	lncli -n=$(NETWORK) newaddress p2wkh 

geninvoice:
	lncli -n=$(NETWORK) addinvoice -amt $(AMOUNT) 

connect:
	lncli -n=$(NETWORK) connect $(PEER)

openchannel:
	lncli -n=$(NETWORK) openchannel  $(PEER) $(AMOUNT)

payinvoice:
	lncli -n=$(NETWORK) payinvoice $(INVOICE)
	

# docker-build:
# 	docker build \
# 	-t lnd_testnet \
# 	.

# docker-run:
# 	docker run -it -d --rm --name lnd_testnet \
# 	-p 9735:9735 	\
# 	-p 18333:18333 \
# 	--user "$(id -u):$(id -g)" \
# 	-v $(PWD)/:.lnd \
# 	lnd_testnet

# docker-attach:
# 	docker attach --detach-keys="ctrl-a" lnd_testnet
