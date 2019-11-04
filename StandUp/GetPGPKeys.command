#!/bin/sh

#  GetPGPKeys.command
#  StandUp
#
#  Created by Peter on 02/11/19.
#  Copyright © 2019 Peter. All rights reserved.
echo "Downloading Bitcoin Core release keys..."
mkdir ~/FullyNoded
mkdir ~/FullyNoded/BitcoinReleaseKeys
/usr/local/bin/wget -O ~/FullyNoded/BitcoinReleaseKeys/SHA256SUMS.asc https://bitcoin.org/bin/bitcoin-core-0.19.0/test.rc3/SHA256SUMS.asc
echo "Downloading Laanwj PGP signature..."
/usr/local/bin/wget -O ~/FullyNoded/laanwj-releases.asc https://bitcoin.org/laanwj-releases.asc
echo "Done"
