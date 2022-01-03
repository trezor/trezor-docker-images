#!/bin/bash

echo "Starting bitcoin regtest backend service"
bin/bitcoind -blockfilterindex -datadir=/opt/coins/data/bitcoin_regtest/backend -conf=/opt/coins/nodes/bitcoin_regtest/bitcoin_regtest.conf &

sleep 5

# generate test wallet and blocks
bin/bitcoin-cli -rpcport=18021 -rpcuser=rpc -rpcpassword=rpc createwallet "tenv-wallet"
bin/bitcoin-cli -rpcport=18021 -rpcuser=rpc -rpcpassword=rpc -generate 150
bin/bitcoin-cli -rpcport=18021 -rpcuser=rpc -rpcpassword=rpc settxfee 0.00001

echo -e "Starting electrs node."
/root/electrs --network regtest --cookie-file /root/.bitcoin/regtest/.cookie --txid-limit 0 -vvv --jsonrpc-import