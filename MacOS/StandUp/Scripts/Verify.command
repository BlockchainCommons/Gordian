#!/bin/sh

#  Verify.command
#  StandUp
#
#  Created by Peter on 07/11/19.
#  Copyright © 2019 Blockchain Commons, LLC

if [ -d ~/StandUp/BitcoinCore ]; then

  cd ~/StandUp/BitcoinCore
  shasum -c SHA256SUMS.asc 2<&1 | grep $BINARY_NAME

else

  echo "No ~/StandUp/BitcoinCore directory"

fi

exit 1
