#!/usr/bin/env sh
set -ex

# Testnet support
if [ "$TESTNET" = true ]; then
  FLAGS='--testnet'
fi

# Graceful shutdown
trap 'pkill -TERM -P1; electrum stop; exit 0' SIGTERM

# Set config
electrum $FLAGS setconfig rpcuser ${ELECTRUM_USER}
electrum $FLAGS setconfig rpcpassword ${ELECTRUM_PASSWORD}
electrum $FLAGS setconfig rpchost 0.0.0.0
electrum $FLAGS setconfig rpcport 7000

# XXX: Check load wallet or create

# Run application
electrum $FLAGS daemon -d

# Loading wallet if exists
if [ -e "/home/electrum/.electrum/wallets/default_wallet" ]
then
  echo "Loading wallet."
  electrum load_wallet
fi

# Wait forever
while true; do
  tail -f /dev/null & wait ${!}
done
