#!/bin/sh

#  TorStatus.command
#  StandUp
#
#  Created by Peter on 15/11/19.
#  Copyright © 2019 Blockchain Commons, LLC
sudo -u $(whoami) /usr/local/bin/brew services list | grep tor
echo "Done"
exit 1
