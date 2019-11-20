#!/bin/sh

#  IsBitcoinOn.command
#  StandUp
#
#  Created by Peter on 19/11/19.
#  Copyright © 2019 Peter. All rights reserved.
#~/StandUp/BitcoinCore/bitcoin-0.18.1/bin/bitcoin-cli getblockchaininfo
sudo -u $(whoami) ~/StandUp/BitcoinCore/$PREFIX/bin/bitcoin-cli getblockchaininfo
echo "Done"
exit
