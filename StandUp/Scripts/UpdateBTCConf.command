#!/bin/sh

#  UpdateBTCConf.command
#  StandUp
#
#  Created by Peter on 13/11/19.
#  Copyright © 2019 Peter. All rights reserved.
echo "Updating bitcoin.conf"
cd "$DATADIR"
echo "$CONF" > bitcoin.conf
echo "Updated "$DATADIR"/bitcoin.conf to "$CONF""
echo "Done"
exit
