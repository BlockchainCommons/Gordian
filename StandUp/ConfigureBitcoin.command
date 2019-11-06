#!/bin/sh

#  ConfigureBitcoin.command
#  StandUp
#
#  Created by Peter on 05/11/19.
#  Copyright © 2019 Peter. All rights reserved.
echo 'rpcuser=user\nrpcpassword=password\nserver=1\nprune=0\ntxindex=1\nregtest=1\n#bind=127.0.0.1\n#proxy=127.0.0.1:9050\n#listen=1\n#debug=tor\n[regtest]\nrpcport=18443' >> ~/Library/Application\ Support/Bitcoin/bitcoin.conf
exit
