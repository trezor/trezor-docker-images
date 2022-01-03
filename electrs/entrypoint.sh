#!/bin/bash

echo -e "\nStarting bitcoin node.\n"
/root/bitcoind -regtest -server -fallbackfee=0.0002 -rpcallowip=0.0.0.0/0 -rpcbind=0.0.0.0 -rpcport=18021 -rpcuser=rpc -rpcpassword=rpc -blockfilterindex=1 -peerblockfilters=1 

echo -e "\nWaiting for bitcoin node.\n"
until /root/bitcoin-cli -regtest -datadir=/root/.bitcoin -rpcport=18021 -rpcuser=rpc -rpcpassword=rpc getblockchaininfo; do
    sleep 1
done
echo -e "\nCreate tenv-test wallet.\n"
/root/bitcoin-cli -regtest -datadir=/root/.bitcoin -rpcport=18021 -rpcuser=rpc -rpcpassword=rpc createwallet tenv-test

echo -e "\nGenerating 150 bitcoin blocks.\n"
ADDR=$(/root/bitcoin-cli -regtest -datadir=/root/.bitcoin -rpcwallet=tenv-test getnewaddress)
/root/bitcoin-cli -regtest -datadir=/root/.bitcoin -rpcport=18021 -rpcuser=rpc -rpcpassword=rpc generatetoaddress 150 $ADDR

echo -e "\nStarting electrs node.\n"
/root/electrs --network regtest --txid-limit 0 -vvv --jsonrpc-import