#!/bin/sh

#  StandDown.command
#  StandUp
#
#  Created by Peter on 13/11/19.
#  Copyright © 2019 Peter. All rights reserved.
echo "Removing ~/StandUp"
rm -R ~/StandUp
echo "Removing /usr/local/etc/tor"
rm -R /usr/local/etc/tor
echo "Removing /usr/local/var/lib/tor"
rm -R /usr/local/var/lib/tor
echo "Stopping Tor..."
/usr/local/bin/brew services stop tor
echo "Uninstalling Tor..."
/usr/local/bin/brew uninstall tor
#echo "Removing Tor..."
#/usr/local/bin/brew remove tor
echo "Finished"
exit
