## Security for Your Bitcoin-Standup

The following security advisories are intended to ensure the security of your *Bitcoin-Standup* full node.

## 1. Do Not Use a VPS for Real Funds

*Bitcoin-Standup* can allow you to create a full-node on a VPS run by a third-party. If you are testing out the Linux Scripts, you are probably doing so on a VPS.

Do *not* place any significant real funds on a full node on a VPS.  A VPS-based install could still be useful as a wallet-less full node connected remotely to a more secure wallet that signs the keys elsewhere, but a higher level of security is required for real funds. See http://blog.thestateofme.com/2012/03/03/lessons-to-be-learned-from-the-linode-bitcoin-incident/ for reasons why.

## 2. Do Use Tor v3 Authentication

Tor V3 hidden services have new and improved built-in functionality for authenticating client connections to servers, whereby the client stores a private key that is kept secret from everyone else, and where the linked public key is stored in a special directory called `authorized_clients` on your StandUp server which lives at your `HiddenServiceDir`  > `/usr/local/var/lib/tor/standup/authorized_clients`.

This can be used to solve the problem of a "malicious maid" or an easedropping hacker who might see the QuickConnect QR code from *Bitcoin-Standup*. Without the two-factor authentication of the `authorized_clients`, the bad actor could access your node and its bitcoins. With two-factor enabled, they can't get in.  Your device (e.g. the client) is the *only* device in the world that is able to remotely access your node.  (Of course, if someone has access to your node they can produce their own key pair and add the public key into the hidden service ... but if they already have access to your node and hidden service then this attack vector is somewhat irrelevant. )

### Enabling Two-Factor Authentication

To use two-factor authentication a trusted and separate isolated device (e.g. the client) produces a private key and public key. The owner of the server must then physically add the public key to the `authorized_clients` directory on the server. In this way you can also share access to your node with trusted family and friends. Tor V3 hidden services support up to ~330 different public keys stored in the `authorized_clients` directory (link to source). 

For a detailed guide see [this link](https://github.com/AnarchoTechNYC/meta/wiki/Connecting-to-an-authenticated-Onion-service#connecting-to-authenticated-version-3-onion-services); for a simple video tutorial that links  iOS *GordianWallet-iOS*  to a Bitcoin-StandUp node, see [this link](https://youtu.be/pSm2VftTCBI) (TO DO create demo videos for GordianWallet-iOS).

#### Using 2FA for Standup and GordianWallet-iOS

You can also follow these instructions if you have downloaded and installed macOS *GordianNode-macOS.app* and iOS *GordianWallet-iOS.* 

In *GordianWallet-iOS*, the private key is stored encrypted locally on the device. The user can not access it, and the encryption key for the private key is stored on your keychain. Whenever you connect to your node, the key is decrypted and stored in your temporary `torrc`, file which is integrated into the *GordianWallet-iOS* Tor thread. The public key, however, is not sensitive as it only works in conjunction with the private key. Thus it can be easily accessed from *GordianWallet-iOS*.

To share the linked public key from *GordianWallet-iOS*, go to settings and tap "Export Authentication Public Key" as pictured below:

<img src="https://github.com/Fonta1n3/Bitcoin-Standup/blob/master/Images/StandUp_Remote_Settings.PNG" alt="export authentication public key" width="250"/>

This will pop up a QR code which you may scan from your Mac to input the key into the macOS *GordianNode-macOS.app*:

<img src="https://github.com/Fonta1n3/Bitcoin-StandUp/blob/master/Images/StandUp_Remote_QR.PNG" alt="export the public key" width="250"/>

#### Entering the Key By Hand

If you prefer, you can enter the public key by hand.

The public key text, which looks like `descriptor:x25519:JNEF892349FH24HF872H4FU2H387H3R982NFN238HF928`, is  automatically copied to your clipboard for easy cut and pasting. If you prefer to enter your public key manually, you would go to the computer that has *GordianNode-macOS.app* installed and find your `HiddenServiceDir`, which is `/usr/local/var/lib/tor/standup/authorized_clients`. You would then open the `authorized_clients` directory and add a file which contains only the public key exactly as *GordianWallet-iOS* exports it. The filename must have a `.auth` extension.

But of course you are using *Bitcoin-StandUp* so the process is as easy as a click. In macOS *GordianNode-macOS.app* go to "Settings" and paste in the public key just as iOS *GordianWallet-iOS* exported it, then tap "Add".

<img src="https://github.com/Fonta1n3/Bitcoin-StandUp/blob/master/Images/paste.png" alt="paste the public key" width="400"/>

<img src="https://github.com/Fonta1n3/Bitcoin-StandUp/blob/master/Images/yes.png" alt="tap yes" width="400"/>

<img src="https://github.com/Fonta1n3/Bitcoin-StandUp/blob/master/Images/ok.png" alt="tap yes" width="400"/>

*GordianNode-macOS.app* then simply creates a random filename with a `.auth` extension, writes the public key to it, and saves it to `/usr/local/var/lib/tor/standup/authorized_clients/`.

