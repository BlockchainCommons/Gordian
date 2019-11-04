#!/bin/sh

#  GetBrew.command
#  StandUp
#
#  Created by Peter on 03/11/19.
#  Copyright © 2019 Peter. All rights reserved.
# This does not yet work..
# If we are going to use scrap.sh as a prerequisite then this is not needed...
echo "Downloading and installing brew..."
cd /usr/local
mkdir homebrew
sudo chown -R $(whoami) /usr/local/homebrew
cd homebrew
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
echo "Done"
exit
