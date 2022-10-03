from client_conf import ALICE_DOCKER, BOB_DOCKER, BITCOIN_DOCKER
from lnd import LndClient, PeerInfo
from client import BtcClient

import logging

"""
Recurrent Payment over LN

Check if target node is connected and is a peer.
Connect to the peer
Check if there is an open channel,
Open the channel if not
Do a recurrent payment using schedule library

"""
logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s', )
logger = logging.getLogger('main')
    

alice = LndClient(ALICE_DOCKER)
bob =  LndClient(BOB_DOCKER)
bitcoin_node = BtcClient(BITCOIN_DOCKER)

logger.info("Alice PubKey: ", alice.pubkey)
logger.info("Bob PubKey: ", bob.pubkey)


def fund_node(bitcoin_node, ln_node, amount):
    address = ln_node.address().address
    logger.info(f"Funding {ln_node} with {amount} BTC at {address}")
    bitcoin_node.sendtoaddress(address, amount)
    bitcoin_node.generate(6)
    logger.info(ln_node.wallet_balance())
    logger.info("Funding complete")
    
    
fund_node(bitcoin_node, alice, 4)
fund_node(bitcoin_node, bob, 3)


logger.info(f"[{alice}] Connecting to {bob.host}..")    
alice.connect_peer(bob.pubkey, bob.host)
logger.info(f"[{alice}] Connected to {bob.host}!")    

def open_channel(node, pubkey, amount):
    
    logger.info(f"[{node}] Opening channel with {pubkey}..")
    
    params = {
        "node_pubkey_string": pubkey,
        "local_funding_amount": amount
    }
    node.open_channel(**params)
    logger.info(f"[{node}] Channel with {pubkey} opened!")


if not alice.channel_exists_with_node(bob.pubkey):
    open_channel(alice, bob.pubkey, 1000000)
else: 
    logger.info("Channel with Bob already exists")
    