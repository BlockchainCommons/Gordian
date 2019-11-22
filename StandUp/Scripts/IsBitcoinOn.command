#!/bin/sh

#  IsBitcoinOn.command
#  StandUp
#
#  Created by Peter on 19/11/19.
#  Copyright © 2019 Peter. All rights reserved.
sudo -u $(whoami) ~/StandUp/BitcoinCore/$PREFIX/bin/bitcoin-cli -datadir=$DATADIR  -chain=$CHAIN getblockchaininfo
echo "Done"
exit
