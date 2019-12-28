#!/bin/sh

#  RefreshHS.command
#  StandUp
#
#  Created by Peter on 24/11/19.
#  Copyright © 2019 Blockchain Commons, LLC
echo "Refreshing hidden service..."
echo "Stopping Tor..."
sudo -u $(whoami) /usr/local/bin/brew services stop tor
echo "Removing:\n/usr/local/var/lib/tor/standup/hostname\n/usr/local/var/lib/tor/standup/hs_ed25519_public_key\n/usr/local/var/lib/tor/standup/hs_ed25519_secret_key"
rm -f /usr/local/var/lib/tor/standup/hostname
rm -f /usr/local/var/lib/tor/standup/hs_ed25519_public_key
rm -f /usr/local/var/lib/tor/standup/hs_ed25519_secret_key
echo "Starting Tor..."
sudo -u $(whoami) /usr/local/bin/brew services start tor
echo "Done"
exit 1
