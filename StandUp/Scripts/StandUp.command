#!/bin/sh

#  StandUp.command
#  StandUp
#
#  Created by Peter on 07/11/19.
#  Copyright © 2019 Peter. All rights reserved.
echo "Creating ~/StandUp/BitcoinCore0.19.0/..."
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
echo "Downloading https://bitcoin.org/bin/bitcoin-core-0.19.0/test.rc3/SHA256SUMS.asc"
curl https://bitcoin.org/bin/bitcoin-core-0.19.0/test.rc3/SHA256SUMS.asc -o ~/StandUp/BitcoinCore0.19.0/SHA256SUMS.asc -s
echo "Saved to ~/StandUp/BitcoinCore0.19.0/SHA256SUMS.asc"
echo "Downloading Laanwj PGP signature..."
curl https://bitcoin.org/laanwj-releases.asc -o ~/StandUp/BitcoinCore0.19.0/laanwj-releases.asc -s
echo "Saved to ~/StandUp/BitcoinCore0.19.0/laanwj-releases.asc"
echo "Downloading Bitcoin Core 0.19.0 from https://bitcoin.org/bin/bitcoin-core-0.19.0/test.rc3/bitcoin-0.19.0rc3-osx64.tar.gz"
cd ~/StandUp/BitcoinCore0.19.0
curl https://bitcoin.org/bin/bitcoin-core-0.19.0/test.rc3/bitcoin-0.19.0rc3-osx64.tar.gz -o ~/StandUp/BitcoinCore0.19.0/bitcoin-0.19.0rc3-osx64.tar.gz --progress-bar
echo "Checking sha256 checksums bitcoin-0.19.0rc3-osx64.tar.gz against SHA256SUMS.asc"
ACTUAL_SHA=$(shasum -a 256 bitcoin-0.19.0rc3-osx64.tar.gz | awk '{print $1}')
EXPECTED_SHA=$(grep osx64 SHA256SUMS.asc | awk '{print $1}')
echo "See two signatures (they should match):"
echo $ACTUAL_SHA
echo $EXPECTED_SHA
if [ "$ACTUAL_SHA" == "$EXPECTED_SHA" ];
then
echo "Signatures match"
echo "Unpacking bitcoin-0.19.0rc3-osx64.tar.gz"
tar -zxvf bitcoin-0.19.0rc3-osx64.tar.gz
echo "Creating bitcoin.conf at: ~/Library/Application Support/Bitcoin/bitcoin.conf"
echo "datadir="$DATADIR"\nrpcuser="$RPCUSER"\nrpcpassword=******\nserver=1\nprune="$PRUNE"\ntxindex="$TXINDEX"\nrpcallowip=127.0.0.1\nbindaddress=127.0.0.1\nproxy=127.0.0.1:9050\nlisten=1\ndebug=tor\ntestnet="$TESTNET"\nregtest="$REGTEST"\n[main]\nrpcport=8332\n[test]\nrpcport=18332\n[regtest]\nrpcport=18443"
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
echo "Installing tor..."
/usr/local/bin/brew install tor
echo "Creating torrc file"
cp /usr/local/etc/tor/torrc.sample /usr/local/etc/tor/torrc
echo "Configuring tor for V3 hidden service"
sed -i -e 's/#ControlPort 9051/ControlPort 9051/g' /usr/local/etc/tor/torrc
sed -i -e 's/#CookieAuthentication 1/CookieAuthentication 1/g' /usr/local/etc/tor/torrc
sed -i -e 's/## address y:z./## address y:z.\
\
HiddenServiceDir \/usr\/local\/var\/lib\/tor\/standup\/\
HiddenServiceVersion 3\
HiddenServicePort 18332 127.0.0.1:18332\
HiddenServicePort 18443 127.0.0.1:18443\
HiddenServicePort 8332 127.0.0.1:8332/g' /usr/local/etc/tor/torrc
echo "Creating hidden service directory at /usr/local/var/lib/tor/standup"
mkdir /usr/local/var/lib
mkdir /usr/local/var/lib/tor
mkdir /usr/local/var/lib/tor/standup
chmod 700 /usr/local/var/lib/tor/standup
echo "Congratulations you are now StoodUp!\nClick the back button if this screen does not dismiss automatically"
echo "Starting Tor as a service (it will automatically start every time you turn on your computer).."
/usr/local/bin/brew services start tor
exit
else
echo "Signatures do not match! Terminating..."
fi
exit
