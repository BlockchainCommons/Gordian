#!/bin/sh

#  StandUp.command
#  StandUp
#
#  Created by Peter on 07/11/19.
#  Copyright © 2019 Peter. All rights reserved.
echo "Downloading Bitcoin Core release keys..."
RPCPASSWORD="$1"
RPCUSER="$2"
DATADIR="$3"
PRUNE="$4"
MAINNET="$5"
TESTNET="$6"
REGTEST="$7"
TXINDEX="$8"
mkdir ~/StandUp
mkdir ~/StandUp/BitcoinCore0.19.0
curl https://bitcoin.org/bin/bitcoin-core-0.19.0/test.rc3/SHA256SUMS.asc -o ~/StandUp/BitcoinCore0.19.0/SHA256SUMS.asc -s
echo "Done"
echo "Downloading Laanwj PGP signature..."
curl https://bitcoin.org/laanwj-releases.asc -o ~/StandUp/BitcoinCore0.19.0/laanwj-releases.asc -s
echo "Done"
echo "Downloading Bitcoin Core 0.19.0..."
cd ~/StandUp/BitcoinCore0.19.0
curl https://bitcoin.org/bin/bitcoin-core-0.19.0/test.rc3/bitcoin-0.19.0rc3-osx64.tar.gz -o ~/StandUp/BitcoinCore0.19.0/bitcoin-0.19.0rc3-osx64.tar.gz --progress-bar
tar -zxvf bitcoin-0.19.0rc3-osx64.tar.gz
mkdir ~/Library/Application\ Support/Bitcoin
cat <<EOF >~/Library/Application\ Support/Bitcoin/bitcoin.conf
datadir=$DATADIR
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
echo "Done"
echo "Setting up Tor..."
/usr/local/bin/brew install tor
cp /usr/local/etc/tor/torrc.sample /usr/local/etc/tor/torrc
sed -i -e 's/#ControlPort 9051/ControlPort 9051/g' /usr/local/etc/tor/torrc
sed -i -e 's/#CookieAuthentication 1/CookieAuthentication 1/g' /usr/local/etc/tor/torrc
sed -i -e 's/## address y:z./## address y:z.\
\
HiddenServiceDir \/usr\/local\/var\/lib\/tor\/standup\/\
HiddenServiceVersion 3\
HiddenServicePort 18332 127.0.0.1:18332\
HiddenServicePort 18443 127.0.0.1:18443\
HiddenServicePort 8332 127.0.0.1:8332/g' /usr/local/etc/tor/torrc
mkdir /usr/local/var/lib
mkdir /usr/local/var/lib/tor
mkdir /usr/local/var/lib/tor/standup
chmod 700 /usr/local/var/lib/tor/standup
echo "Congratulations you are now StoodUp!"
echo "Starting Tor.."
/usr/local/bin/brew services start tor
exit
