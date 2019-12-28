#!/bin/sh

#  IsBitcoinOn.command
#  StandUp
#
#  Created by Peter on 19/11/19.
#  Copyright © 2019 Blockchain Commons, LLC
if [ -d ~/StandUp/BitcoinCore ]; then

  ~/StandUp/BitcoinCore/$PREFIX/bin/bitcoin-cli -datadir="$DATADIR" getblockchaininfo

else

  PATH="$(command -v bitcoin-cli)"
  #$PATH -datadir="$DATADIR" getblockchaininfo
  
  if ! [ "$DATADIR" == "" ]; then
  
    $PATH -datadir="$DATADIR" getblockchaininfo
    
  else
  
    $PATH getblockchaininfo
  
  fi

fi

echo "Done"
exit 1
