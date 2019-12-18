# StandUp-iOS

StandUp-iOS is currently hardcoded to work on testnet, it should not work properly on a mainnet node right now.

Currently the app is hardcoded to add a testnet node, instead of scanning a btcstandup:// QuickConnect QR code.

The node it is hardcoded to connect to has Tor V3 authentication setup, the node is on the Blockchain Commons Linode account and can be accessed there. The instance is called `linodestandupsh-ap-south`.

In order to add your Tor V3 authentication key to the testing node ssh into the node as root, then run the following commands:

`cat /var/lib/tor/standup/authorized_clients/<random_string_here>.auth`

Paste in the public key as StandUp-iOS exports it, do this by tapping the lock screen in top left corner of the home screen.

Then restart Tor with `sudo systemctl restart tor.service`

Wait for Tor to restart then tap the refresh button in top right of the home screen of StandUp-iOS. If you get any error while it is creating your wallet then tap the refresh button and it should work.
