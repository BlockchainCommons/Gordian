#!/bin/sh

#  StopBitcoin.command
#  StandUp
#
#  Created by Peter on 19/11/19.
#  Copyright © 2019 Peter. All rights reserved.
sudo -u $(whoami) ~/StandUp/BitcoinCore/$PREFIX/bin/bitcoin-cli -datadir="$DATADIR" stop
echo "Done"
exit
