import time
from bitcoinlib.services.services import Service
from bitcoinlib.scripts import *

from pprint import pprint


start_time = time.time()


srv = Service(providers=['mempool'])

# Get latest block
# blocks = [srv.blockcount()]

# Get first block
# blocks = [1]

# Check first 100000 blocks
# blocks = range(1, 100000)

# Check some more recent blocks
blocks = range(626001, 626002)


for blockid in blocks:
    print("Getting block %s" % blockid)
    block = srv.getblock(blockid, parse_transactions=True, limit=99999)
    print("Found %d transactions" % block.tx_count)

    MAX_TRANSACTIONS = 10000
    count = 0
    count_segwit = 0

    for t in block.transactions[:MAX_TRANSACTIONS]:
        print("=== Deserialize transaction %s (#%d, segwit %d) ===" % (t.txid, count, count_segwit))
        count += 1
        t.verify()
        transaction = t.as_dict()
        # print(transaction)
        for input in transaction['inputs']:
            script = Script.parse(input['script'])
            print(script)

print("--- %s seconds ---" % (time.time() - start_time))
