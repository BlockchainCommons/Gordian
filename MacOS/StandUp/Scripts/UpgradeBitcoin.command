#!/bin/sh

#  UpgradeBitcoin.command
#  StandUp
#
#  Created by Peter on 19/11/19.
#  Copyright © 2019 Blockchain Commons, LLC
echo "Updating to $VERSION"
echo "Removing ~/StandUp"
rm -R ~/StandUp
mkdir ~/StandUp
mkdir ~/StandUp/BitcoinCore

echo "Downloading $SHA_URL"
curl $SHA_URL -o ~/StandUp/BitcoinCore/SHA256SUMS.asc -s
echo "Saved to ~/StandUp/BitcoinCore/SHA256SUMS.asc"

echo "Downloading Laanwj PGP signature from https://bitcoin.org/laanwj-releases.asc..."
curl https://bitcoin.org/laanwj-releases.asc -o ~/StandUp/BitcoinCore/laanwj-releases.asc -s
echo "Saved to ~/StandUp/BitcoinCore/laanwj-releases.asc"

echo "Downloading Bitcoin Core $VERSION from $MACOS_URL"
cd ~/StandUp/BitcoinCore
curl $MACOS_URL -o ~/StandUp/BitcoinCore/$BINARY_NAME --progress-bar

echo "Checking sha256 checksums $BINARY_NAME against SHA256SUMS.asc"
ACTUAL_SHA=$(shasum -a 256 $BINARY_NAME | awk '{print $1}')
EXPECTED_SHA=$(grep osx64 SHA256SUMS.asc | awk '{print $1}')

echo "See two signatures (they should match):"
echo $ACTUAL_SHA
echo $EXPECTED_SHA

if [ "$ACTUAL_SHA" == "$EXPECTED_SHA" ]; then

  echo "Signatures match"
  echo "Unpacking $BINARY_NAME"
  tar -zxvf $BINARY_NAME
  echo "You have upgraded to Bitcoin Core $VERSION"
  
else

  echo "Signatures do not match! Terminating..."
  
fi

exit 1
