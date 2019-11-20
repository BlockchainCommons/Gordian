#!/bin/sh

#  GetBitcoinConf.command
#  StandUp
#
#  Created by Peter on 20/11/19.
#  Copyright © 2019 Peter. All rights reserved.
echo "$DATADIR"/bitcoin.conf
cat "$DATADIR"/bitcoin.conf
echo "Done"
exit
