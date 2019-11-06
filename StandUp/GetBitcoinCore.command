#!/bin/sh

#  GetBitcoinCore.command
#  StandUp
#
#  Created by Peter on 02/11/19.
#  Copyright © 2019 Peter. All rights reserved.
echo "Downloading Bitcoin Core 0.19.0..."
cd ~/FullyNoded
mkdir BitcoinCore0.19.0
cd BitcoinCore0.19.0
/usr/local/bin/wget https://bitcoin.org/bin/bitcoin-core-0.19.0/test.rc3/bitcoin-0.19.0rc3-osx64.tar.gz
echo "Done"
exit
