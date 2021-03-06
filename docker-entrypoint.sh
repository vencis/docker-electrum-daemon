#!/usr/bin/env sh
set -ex

# Testnet support
if [ "$TESTNET" = true ]; then
  FLAGS='--testnet'
fi

# Graceful shutdown
trap 'pkill -TERM -P1; electrum $FLAGS stop; exit 0' SIGTERM

# Run application
electrum $FLAGS daemon -d

# Set config
electrum $FLAGS setconfig rpcuser ${ELECTRUM_USER}
electrum $FLAGS setconfig rpcpassword ${ELECTRUM_PASSWORD}
electrum $FLAGS setconfig rpchost 0.0.0.0
electrum $FLAGS setconfig rpcport 7000

# Loading wallet if exists
if [[ -f "/home/electrum/.electrum/wallets/default_wallet" || -f "/home/electrum/.electrum/testnet/wallets/default_wallet" ]]
then
  echo "Loading wallet."
  electrum $FLAGS load_wallet
fi

# Wait forever
while true; do
  tail -f /dev/null & wait ${!}
done
