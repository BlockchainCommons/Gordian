#!/bin/sh

#  RemoveBitcoin.command
#  StandUp
#
#  Created by Peter on 20/11/19.
#  Copyright © 2019 Peter. All rights reserved.
echo "removing "$DATADIR""
sudo -u $(whoami) rm -R "$DATADIR"
"Done"
exit
