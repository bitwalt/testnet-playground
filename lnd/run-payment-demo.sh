#!/bin/bash

#
# Helper functions
#


# run-in-node: Run a command inside a docker container, using the bash shell
function run-in-node () {
	docker exec "$1" /bin/bash -c "${@:2}"
}

# wait-for-cmd: Run a command repeatedly until it completes/exits successfuly
function wait-for-cmd () {
		until "${@}" > /dev/null 2>&1
		do
			echo -n "."
			sleep 1
		done
		echo
}

# wait-for-node: Run a command repeatedly until it completes successfully, inside a container
# Combining wait-for-cmd and run-in-node
function wait-for-node () {
	wait-for-cmd run-in-node $1 "${@:2}"
}


# Start the demo
echo "Starting Payment Demo"

echo "======================================================"
echo
echo "Waiting for nodes to startup"
echo -n "- Waiting for bitcoind startup..."
wait-for-node bitcoind "cli getblockchaininfo | jq -e \".blocks > 101\""
echo -n "- Waiting for bitcoind mining..."
wait-for-node bitcoind "cli getbalance | jq -e \". > 50\""
echo -n "- Waiting for alice-ln startup..."
wait-for-node alice-ln "cli getinfo"
echo -n "- Waiting for bob-ln startup..."
wait-for-node bob-ln "cli getinfo"
echo -n "- Waiting for chan-ln startup..."
wait-for-node chan-ln "cli getinfo"

echo "======================================================"
echo
echo "Getting node IDs"
alice_address=$(run-in-node alice-ln "cli getinfo | jq -r .identity_pubkey")
bob_address=$(run-in-node bob-ln "cli getinfo | jq -r .identity_pubkey")
chan_address=$(run-in-node chan-ln "cli getinfo | jq -r .identity_pubkey")

# Show node IDs
echo "- alice-ln:  ${alice_address}"
echo "- bob-ln:    ${bob_address}"
echo "- chan-ln:   ${chan_address}"

echo "======================================================"
echo
echo "Waiting for Lightning nodes to sync the blockchain"
echo -n "- Waiting for alice-ln chain sync..."
wait-for-node alice-ln "cli getinfo | jq -e \".synced_to_chain == true\""
echo -n "- Waiting for bob-ln chain sync..."
wait-for-node bob-ln "cli getinfo | jq -e \".synced_to_chain == true\""
echo -n "- Waiting for chan-ln chain sync..."
wait-for-node chan-ln "cli getinfo | jq -e \".synced_to_chain == true\""

echo "======================================================"
echo
echo "Setting up connections and channels"
echo "- alice-ln to bob-ln"

# Connect only if not already connected
run-in-node alice-ln "cli listpeers | jq -e '.peers[] | select(.pub_key == \"${bob_address}\")' > /dev/null" \
&& {
	echo "- alice-ln already connected to bob-ln"
} || {
	echo "- Open connection from alice-ln node to bob-ln's node"
	wait-for-node alice-ln "cli connect ${bob_address}@bob-ln"
}

# Create channel only if not already created
run-in-node alice-ln "cli listchannels | jq -e '.channels[] | select(.remote_pubkey == \"${bob_address}\")' > /dev/null" \
&& {
	echo "- alice-ln->bob-ln channel already exists"
} || {
	echo "- Create payment channel alice-ln->bob-ln"
	wait-for-node alice-ln "cli openchannel ${bob_address} 1000000"
}
echo "bob-ln to chan-ln"
run-in-node bob-ln "cli listpeers | jq -e '.peers[] | select(.id == \"${chan_address}\")' > /dev/null" \
&& {
	echo "- bob-ln already connected to chan-ln"
} || {
	echo "- Open connection from bob-ln's node to chan-ln's node"
	wait-for-node bob-ln "cli connect ${chan_address}@chan-ln"
}
run-in-node bob-ln "cli listchannels | jq -e '.channels[] | select(.destination == \"${chan_address}\")' > /dev/null" \
&& {
	echo "- bob-ln->chan-ln channel already exists"
} || {
	echo "- Create payment channel bob-ln->chan-ln"
	wait-for-node bob-ln "cli fundchannel ${chan_address} 1000000"
}

echo "All channels created"
echo "======================================================"
echo
echo "Waiting for channels to be confirmed on the blockchain"
echo -n "- Waiting for alice-ln channel confirmation..."
wait-for-node alice-ln "cli listchannels | jq -e '.channels[] | select(.remote_pubkey == \"${bob_address}\" and .active == true)'"
echo "- alice-ln->bob-ln connected"
echo -n "- Waiting for bob-ln channel confirmation..."
wait-for-node bob-ln "cli listchannels | jq -e '.channels[] | select(.destination == \"${chan_address}\" and .active == true)'"
echo "- bob-ln->chan-ln connected"
echo "All channels confirmed"


echo "======================================================"
echo -n "Check alice-ln's route to chan-ln: "
run-in-node alice-ln "cli queryroutes --dest \"${chan_address}\" --amt 10000" > /dev/null 2>&1 \
&& {
	echo "alice-ln has a route to chan-ln"
} || {
	echo "alice-ln doesn't yet have a route to chan-ln"
	echo "Waiting for alice-ln graph sync. This may take a while..."
	wait-for-node alice-ln "cli describegraph | jq -e '.edges | select(length >= 1)'"
	echo "- alice-ln knows about 1 channel"
	wait-for-node alice-ln "cli describegraph | jq -e '.edges | select(length >= 2)'"
	echo "- alice-ln knows about 2 channels"
	echo "alice-ln knows about all the channels"
}

echo "======================================================"
echo
echo "Get 10k sats invoice from chan-ln"
chan_invoice=$(run-in-node chan-ln "cli addinvoice 10000 | jq -r .payment_request")
echo "- chan-ln invoice: "
echo ${chan_invoice}

echo "======================================================"
echo
echo "Attempting payment from alice-ln to chan-ln"
run-in-node alice-ln "cli payinvoice --json --force ${chan_invoice} | jq -e '.failure_reason == \"FAILURE_REASON_NONE\"'" > /dev/null && {
	echo "Successful payment!"
} ||
{
	echo "Payment failed"
}
