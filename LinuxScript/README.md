# Linux Scripts
There are two linux based StandUp scripts; `StandUp.sh` and `LinodeStandUp.sh`.

`StandUp.sh` is a linux script and can be used on any Debian VPS (tested on Debian Stretch and Ubuntu 18.04).

`LinodeStandUp.sh` is built as a StackScript for the Linode platform and can be used as is.

## Status

This project is an early **Work-In-Progress**, so that we can prototype, discover additional requirements, and get feedback from the broader Bitcoin-Core Developer Community. ***It has not yet been peer-reviewed or audited. It is not yet ready for production uses. Use at your own risk.***

### Disclaimer

*The information and files included in this repository are intended to inform a set of best practices. It may not address risks specific to your situation, and if it does not, you should modify appropriately. While this information may inform best practices, there is no guarantee that following this advice will sufficiently ensure the security of your digital assets. In addition, this information is only a window on best practices at a specific moment in time. Be aware that the Bitcoin and blockchain ecosystems may have evolved, and the risk assessments of specific solutions may have changed since the publication of this document. In other words: be cautious, be careful, and be aware of the current Bitcoin and blockchain landscape before you use this information.*

*It is not a good idea to store large amounts of Bitcoin on a VPS, ideally you should use this as a watch-only wallet. This script is experimental and has not been widely tested. The creators are not responsible for loss of funds. If you are not familiar with running a node or how Bitcoin works then we urge you to use this in testnet so that you can use it as a learning tool.*

## What does it do?

This script installs the latest stable version of Tor, Bitcoin Core, Uncomplicated Firewall (UFW), Debian updates, enables automatic updates for Debian for good security practices, installs a random number generator, and optionally a QR encoder and an image displayer.

The script will display a `btcstandup://` uri in plain text which you can convert to a QR Code and scan with FullyNoded to connect remotely.

Upon completion of the script there will be a QR code saved to `/qrcode.png` which you can open and scan. You can use `sudo apt-get install fim` then `fim -a qrcode.png` to display the QR in a terminal (as root).

It is highly recommended to add a Tor V3 pubkey for cookie authentication so that even if your QR code is compromised an attacker would not be able to access your node. It is also recommended to delete the `/qrcode.png`, `/standup.log`, and `/standup.err` files once you get connected.

`StandUp.sh` sets Tor and Bitcoin Core up as `systemd` services so that they start automatically after crashes or reboots. By default it sets up a pruned testnet node, a Tor V3 hidden service controlling your `rpcport` and enables the firewall to only allow incoming connections for SSH. If you supply a `SSH_KEY` in the arguments it allows you to easily access your node via SSH using your rsa pubkey, if you add `SYS_SSH_IP`'s it will only accept SSH connections from those IP's.

`StandUp.sh` will create a user called `standup`, and assign the optional password you give it in the arguments.

StandUp.sh will create two logs in your root directory, to read them run:
`$ cat standup.err`
`$ cat standup.log`

## Install

In order to run this script you need to be logged in as root, and enter in the commands listed below:
(the $ represents a terminal command prompt, do not actually type in a $)

First you need to give the root user a password:
`$ sudo passwd`

Then you need to switch to the root user:
`$ su - root`

Then create the file for the script:
`$ nano standup.sh`

Nano is a text editor that works in a terminal, you need to paste the entire contents of this script into your terminal after running the above command, then you can type:
`control x` (this starts to exit nano)
`y`         (this confirms you want to save the file)
`return`    (just press enter to confirm you want to save and exit)

Then we need to make sure the script can be executable with:
`$ chmod +x standup.sh`

After that you can run the script with the optional arguments like so:
`$ ./standup.sh "<insert Tor V3 pubkey>" "<insert node type>" "<insert ssh key>" "<insert ssh allowed IP's>" "<insert password for standup user>"`

The arguments are optional, you can read more detail about them in the script itself.
