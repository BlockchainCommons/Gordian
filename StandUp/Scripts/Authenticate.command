#!/bin/sh

#  Authenticate.command
#  StandUp
#
#  Created by Peter on 09/11/19.
#  Copyright © 2019 Peter. All rights reserved.
PUBKEY="$1"
FILENAME="$2"
echo $PUBKEY > /usr/local/var/lib/tor/standup/authorized_clients/"$FILENAME".auth
exit
