#!/bin/sh

#  UpdateBTCConf.command
#  StandUp
#
#  Created by Peter on 13/11/19.
#  Copyright © 2019 Peter. All rights reserved.
# Not having luck with this method...
#echo "Updating bitcoin.conf"
#KEY_TO_UPDATE="$1"
#NEW_VALUE="$2"
#sed -i "s/^"$KEY_TO_UPDATE"= .*$/"$KEY_TO_UPDATE"="$NEW_VALUE"/" ~/Library/Application\ Support/Bitcoin/bitcoin.conf
#sed -r 's/(^.*)Snake/\1PacMan' .ignore
#sed -r "s/(^.*)"$KEY_TO_UPDATE"=/\1"$KEY_TO_UPDATE"=""$NEW_VALUE" ~/Library/Application\ Support/Bitcoin/bitcoin.conf
#sed -i 's:^projdir.*$:projdir PacMan:g' .ignore
#sed -i "s:^"$KEY_TO_UPDATE"=.*$:"$KEY_TO_UPDATE"=""$NEW_VALUE":g" ~/Library/Application\ Support/Bitcoin/bitcoin.conf
#echo "Updated "$KEY_TO_UPDATE"="$NEW_VALUE" in bitcoin.conf"
echo "Updating bitcoin.conf"
RPCPASSWORD="$1"
RPCUSER="$2"
DATADIR="$3"
PRUNE="$4"
MAINNET="$5"
TESTNET="$6"
REGTEST="$7"
TXINDEX="$8"
WALLET_DISABLED="$9"
mkdir ~/Library/Application\ Support/Bitcoin
cat <<EOF >~/Library/Application\ Support/Bitcoin/bitcoin.conf
datadir=$DATADIR
walletdisabled=$WALLET_DISABLED
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
server=1
prune=$PRUNE
txindex=$TXINDEX
rpcallowip=127.0.0.1
bindaddress=127.0.0.1
proxy=127.0.0.1:9050
listen=1
debug=tor
testnet=$TESTNET
regtest=$REGTEST
[main]
rpcport=8332
[test]
rpcport=18332
[regtest]
rpcport=18443
EOF
echo "datadir="$DATADIR"\nwalletdisabled="$WALLET_DISABLED"\nrpcuser="$RPCUSER"\nrpcpassword=******\nserver=1\nprune="$PRUNE"\ntxindex="$TXINDEX"\nrpcallowip=127.0.0.1\nbindaddress=127.0.0.1\nproxy=127.0.0.1:9050\nlisten=1\ndebug=tor\ntestnet="$TESTNET"\nregtest="$REGTEST"\n[main]\nrpcport=8332\n[test]\nrpcport=18332\n[regtest]\nrpcport=18443"
echo "Done"
exit
