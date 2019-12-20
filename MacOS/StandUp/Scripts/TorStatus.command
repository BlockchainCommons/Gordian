#!/bin/sh

#  TorStatus.command
#  StandUp
#
#  Created by Peter on 15/11/19.
#  Copyright © 2019 Peter. All rights reserved.
sudo -u $(whoami) /usr/local/bin/brew services list
echo "Done"
exit
