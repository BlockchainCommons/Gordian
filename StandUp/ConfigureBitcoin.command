#!/bin/sh

#  ConfigureBitcoin.command
#  StandUp
#
#  Created by Peter on 05/11/19.
#  Copyright © 2019 Peter. All rights reserved.
mkdir ~/Library/Application\ Support/Bitcoin
cat <<EOF >~/Library/Application\ Support/Bitcoin/bitcoin.conf
rpcuser=user
rpcpassword=password
server=1
prune=0
txindex=1
testnet=1
[test]
rpcport=18332
EOF
exit
