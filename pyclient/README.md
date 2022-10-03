Python bindings for gRPC LND    


### Open channel example

```
request = lnrpc.OpenChannelRequest(
        sat_per_vbyte=<uint64>,
        node_pubkey=<bytes>,
        node_pubkey_string=<string>,
        local_funding_amount=<int64>,
        push_sat=<int64>,
        target_conf=<int32>,
        sat_per_byte=<int64>,
        private=<bool>,
        min_htlc_msat=<int64>,
        remote_csv_delay=<uint32>,
        min_confs=<int32>,
        spend_unconfirmed=<bool>,
        close_address=<string>,
        funding_shim=<FundingShim>,
        remote_max_value_in_flight_msat=<uint64>,
        remote_max_htlcs=<uint32>,
        max_local_csv=<uint32>,
        commitment_type=<CommitmentType>
        )

response = { 
    "chan_pending": <PendingUpdate>,
    "chan_open": <ChannelOpenUpdate>,
    "psbt_fund": <ReadyForPsbtFunding>,
    "pending_chan_id": <bytes>,
}
```
