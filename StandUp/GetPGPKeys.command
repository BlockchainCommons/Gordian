#!/bin/sh

#  GetPGPKeys.command
#  StandUp
#
#  Created by Peter on 02/11/19.
#  Copyright © 2019 Peter. All rights reserved.
echo "Downloading Bitcoin Core release keys..."
mkdir ~/FullyNoded
mkdir ~/FullyNoded/BitcoinReleaseKeys
curl https://bitcoin.org/bin/bitcoin-core-0.19.0/test.rc3/SHA256SUMS.asc -o ~/FullyNoded/BitcoinReleaseKeys/SHA256SUMS.asc
echo "Downloading Laanwj PGP signature..."
curl https://bitcoin.org/laanwj-releases.asc -o ~/FullyNoded/laanwj-releases.asc
echo "Downloading Bitcoin Core 0.19.0..."
cd ~/FullyNoded
mkdir BitcoinCore0.19.0
cd BitcoinCore0.19.0
curl https://bitcoin.org/bin/bitcoin-core-0.19.0/test.rc3/bitcoin-0.19.0rc3-osx64.tar.gz -o ~/FullyNoded/BitcoinCore0.19.0/bitcoin-0.19.0rc3-osx64.tar.gz
tar -zxvf bitcoin-0.19.0rc3-osx64.tar.gz
mkdir ~/Library/Application\ Support/Bitcoin
cat <<EOF >~/Library/Application\ Support/Bitcoin/bitcoin.conf
rpcuser=user
rpcpassword=password
server=1
prune=0
txindex=1
regtest=1
[regtest]
rpcport=18443
EOF
~/FullyNoded/BitcoinCore0.19.0/bitcoin-0.19.0rc3/bin/bitcoin-qt
exit
