#!/bin/bash

echo -e "Starting electrs node."
/bin/electrs --network regtest --txid-limit 0 -vvv --jsonrpc-import