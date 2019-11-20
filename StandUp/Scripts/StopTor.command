#!/bin/sh

#  StopTor.command
#  StandUp
#
#  Created by Peter on 07/11/19.
#  Copyright © 2019 Peter. All rights reserved.
sudo -u $(whoami) /usr/local/bin/brew services stop tor
echo "Done"
exit
