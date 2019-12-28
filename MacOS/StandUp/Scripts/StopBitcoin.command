#!/bin/sh

#  StopBitcoin.command
#  StandUp
#
#  Created by Peter on 19/11/19.
#  Copyright © 2019 Blockchain Commons, LLC
if [ -d ~/StandUp/BitcoinCore ]; then

  ~/StandUp/BitcoinCore/$PREFIX/bin/bitcoin-cli -datadir="$DATADIR" stop

else

  PATH="$(command -v bitcoin-cli)"
  $PATH -datadir="$DATADIR" stop

fi

echo "Done"
exit 1
