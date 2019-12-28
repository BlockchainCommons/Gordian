#!/bin/sh

#  RemoveBitcoin.command
#  StandUp
#
#  Created by Peter on 20/11/19.
#  Copyright © 2019 Blockchain Commons, LLC
echo "removing "$DATADIR""
sudo -u $(whoami) rm -R "$DATADIR"
"Done"
exit 1
