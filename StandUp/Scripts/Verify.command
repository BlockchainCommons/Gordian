#!/bin/sh

#  Verify.command
#  StandUp
#
#  Created by Peter on 07/11/19.
#  Copyright © 2019 Peter. All rights reserved.
# TO DO: do not hard code the tarball, instead get value from SupportedVersion
cd ~/StandUp/BitcoinCore
shasum -c SHA256SUMS.asc 2<&1 | grep $BINARY_NAME
echo "Done"
exit
