from configs import *
from lnd import LndClient
from client import BtcClient

bip_node = {
    "pubkey": "037621d90b5f3673834287d2f87d4c5a014ccad50a973d3b8c6aa5b94c30a537e7",
    "host": "135.125.207.196",
    "port": "9735"
}

BOB_DOCKER = {
    'name': 'Bob',
    'node_host': f'{LND_IP_BOB}:9735',
    'rpc_host': f'{LND_IP_BOB}:10009',
    'tls_cert': '/lnd_share/bob/tls.cert',
    'wallet': '/lnd_share/bob/wallet.db',
    'logs': '/lnd_share/bob/logs/',
    'admin_macaroon': '/lnd_share/bob/admin.macaroon'
}

ALICE_DOCKER = {
    'name': 'Alice',
    'node_host': f'{LND_IP}:9735',
    'rpc_host': f'{LND_IP}:10009',
    'tls_cert': '/lnd_share/alice/tls.cert',
    'wallet': '/lnd_share/alice/wallet.db',
    'logs': '/lnd_share/alice/logs/',
    'admin_macaroon': '/lnd_share/alice/admin.macaroon'
}
BITCOIN_DOCKER = {
    "rpc_user": RPC_USER,
    "rpc_pass": RPC_PASS,
    "host": BITCOIN_IP, 
    "port": RPC_PORT
}

"""
Recurrent Payment over LN

Check if target node is connected and is a peer.
Connect to the peer
Check if there is an open channel,
Open the channel if not
Do a recurrent payment using schedule library

"""

# def fund_node()
    

alice = LndClient(ALICE_DOCKER)
bob =  LndClient(BOB_DOCKER)
bitcoin_node = BtcClient(BITCOIN_DOCKER)

print("Alice PubKey: ", alice.identity_pubkey)
print("Bob PubKey: ", bob.identity_pubkey)

print("Alice Balance: ", alice.address())

def fund_node(bitcoin_node, ln_node, amount):
    address = ln_node.address().address
    print(f"Funding {ln_node} with {amount} BTC at {address}")
    bitcoin_node.sendtoaddress(address, amount)
    bitcoin_node.generate(6)
    print(ln_node.wallet_balance())
    print("Funding complete")
    
fund_node(bitcoin_node, alice, 4)
fund_node(bitcoin_node, bob, 3)
