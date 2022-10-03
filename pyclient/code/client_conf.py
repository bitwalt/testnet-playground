from configs import *

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

CHARLIE_DOCKER = {
    'name': 'Charlie',
    'node_host': f'{LND_IP_CHARLIE}:9735',
    'rpc_host': f'{LND_IP_CHARLIE}:10009',
    'tls_cert': '/lnd_share/charlie/tls.cert',
    'wallet': '/lnd_share/charlie/wallet.db',
    'logs': '/lnd_share/charlie/logs/',
    'admin_macaroon': '/lnd_share/charlie/admin.macaroon'
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