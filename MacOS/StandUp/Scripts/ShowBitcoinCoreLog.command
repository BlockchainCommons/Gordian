#!/bin/sh

#  ShowBitcoinCoreLog.command
#  StandUp
#
#  Created by Peter on 25/11/19.
#  Copyright © 2019 Blockchain Commons, LLC
echo ""$DATADIR"/debug.log"
open "$DATADIR"/debug.log
echo "Done"
exit 1
