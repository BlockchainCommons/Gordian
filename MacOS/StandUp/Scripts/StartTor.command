#!/bin/sh

#  StartTor.command
#  StandUp
#
#  Created by Peter on 06/11/19.
#  Copyright © 2019 Blockchain Commons, LLC
sudo -u $(whoami) /usr/local/bin/brew services start tor
echo "Done"
exit
