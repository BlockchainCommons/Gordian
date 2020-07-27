# Why Run a Full Node?

Running a full node, installed by a program such as *GordianNode-macOS*, offers a number of advantages.

##### 1.  Validation

- Validation is the most important reason to operate a Bitcoin full node. With a full node, Bitcoin users can check whether transactions are valid according to all of Bitcoin's rules. Users can verify that any bitcoins they receive are legitimately mined, correctly signed, and more. This is what makes Bitcoin a trustless solution. Without your own full node you are inherently trusting a third party to tell you how many bitcoins you own and to construct transactions correctly; with your own full node you can personally verify with certainty that your bitcoins are real, that they belong to you, and that they get sent to the intended recipient.

##### 2. Privacy

- Without a full node, you are relying on someone else's server. Therefore, they know all your addresses and spending habits as well how much money you have. Obviously, this is not ideal. Utilizing your own node allows you to use Bitcoin in a much more private way whereby you do not need to leak  your transaction patterns to a third party.
- *GordianNode-macOS* uses Tor for enhanced privacy. When you use the clearnet, all of your devices' network traffic is highly correlatable, making it trivial for third parties to track which websites you visit.  They could easily see Bitcoin related traffic linked to your IP address, and since IP addresses can be tied to physical locations, this poses a risk. This is where Tor comes in: with *GordianNode-macOS* all of your Bitcoin related internet traffic is obfuscated with Tor. For example, you may use the *GordianWallet-iOS* app over Tor to get information from your node and it would be very difficult for any third party to see that your device is speaking to a Bitcoin Core node, let alone what it is specifically doing.

##### 3. Security

- *GordianNode-macOS* installs Bitcoin Core, which is the reference implementation of Bitcoin. That means that you are utilizing one of the most highly peer reviewed and scrutinized pieces of software in the world. The vast majority of the functionality for the *GordianWallet-iOS* app also uses Bitcoin Core, extending these benefits. By using *GordianNode-macOS* and *GordianWallet-iOS* together, you can rest at ease that critical bugs should be minimized.
- Native Tor V3 client authentication is integrated into *GordianNode-macOS*. This is the most secure way of communicating with your node remotely, ensuring that *only* your device has access to your node, even if all other credentials were compromised by an attacker. In short, accessing your Bitcoin Core node with a remote client is most securely done over the Tor network.
- Generally: self custody can be scary, as running a node properly over Tor is not something that most people are comfortable with. The entire purpose of the *GordianNode-macOS* suite of tools is to make this achievable for anyone who can click a mouse and scan a QR code.

##### 4. Liquidity

- Access to funds is a critical component for storing your Bitcoin in a self-sovereign way, where you maintain control and agency. If you are not using your own node you may be encumbered by third-party software limitations, which may not allow you to export your seed or private keys or be interoperable with other Bitcoin software. With *GordianNode-macOS*, you can copy and paste a one-line command and recover your entire wallet using your own node, at any time, with guaranteed compatibility. You can also interlink with the *GordianWallet-iOS* app, which allows you to import seeds, permitting you to access your bitcoins stored on other wallets or apps.

##### 5. Testing and learning

- Utilizing your own node allows you to test the bitcoin network. Simply run the node over testnet and you can experiment with tutorials like [Learning Bitcoin from the Command Line](https://github.com/ChristopherA/Learning-Bitcoin-from-the-Command-Line) and you can experiment with fake money before committing any real funds. A ridiculous percentage of circulating bitcoins have been lost due to misuse or mistakes. *GordianNode-macOS* allows you test everything using your own node, ensuring you are comfortable with how it works (and that it does work) before utilizing mainnet.
