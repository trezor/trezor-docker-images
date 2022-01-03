#!/bin/bash
set -e

echo -e "Starting bitcoin node."
/root/bitcoind -regtest -server -fallbackfee=0.0002 -rpcallowip=0.0.0.0/0 -rpcbind=0.0.0.0 -rpcport=18021 -rpcuser=rpc -rpcpassword=rpc -blockfilterindex=1 -peerblockfilters=1 
