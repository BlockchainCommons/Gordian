#!/bin/sh

#  StandDown.command
#  StandUp
#
#  Created by Peter on 13/11/19.
#  Copyright © 2019 Blockchain Commons, LLC
echo "Removing ~/StandUp"
rm -R ~/StandUp
echo "Removing /usr/local/etc/tor"
rm -R /usr/local/etc/tor
echo "Removing /usr/local/var/lib/tor"
rm -R /usr/local/var/lib/tor
echo "Stopping Tor..."
sudo -u $(whoami) /usr/local/bin/brew services stop tor
echo "Uninstalling Tor..."
sudo -u $(whoami) /usr/local/bin/brew uninstall tor
echo "Finished"
exit 1
