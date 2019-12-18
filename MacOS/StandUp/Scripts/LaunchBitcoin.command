#!/bin/sh

#  LaunchBitcoin.command
#  StandUp
#
#  Created by Peter on 05/11/19.
#  Copyright © 2019 Peter. All rights reserved.
sudo -u $(whoami) ~/StandUp/BitcoinCore/$PREFIX/bin/bitcoin-qt -datadir="$DATADIR"
echo "Done"
exit
