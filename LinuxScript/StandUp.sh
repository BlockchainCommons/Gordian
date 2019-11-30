#!/bin/bash

# This script installs the latest stable version of Tor, Bitcoin Core, Uncomplicated Firewall, debian updates, enables automatic updates for debian for good security practices, installs a random number generator, a QR encoder and an image displayer, you will be prompted to type "y" and enter to install the packages. The QR packages are optional and the script will display the uri in plain text which you can convert to a QR Code yourself. It is highly recommended to add a Tor V3 pubkey for cookie authentication so that even if your QR code is compromised an attacker would not be able to access your node.

# StandUp.sh sets Tor and Bitcoin Core up as services so that they start automatically after crashes or reboots. By default it sets up a pruned testnet node, a Tor V3 hidden service controlling your rpcports and enables the firewall to only allow incoming connections for ssh. If you supply a SSH_KEY in the arguments it allows you to easily access your node via SSH using your rsa pubkey, if you add SYS_SSH_IP's it will only accept SSH connections from those IP's.

# StandUp.sh will create a user called standup, and assing the optional password you give it in the arguments

# StandUp.sh will create two logs, to read them run
# $ cat standup.err
# $ cat standup.log

# In order to run this script you need to be logged in as root, execute the following:
# $ sudo passwd
# follow the prompts for adding a password for the root user
# $ su - root
# enter the password you just created for the root user
# $ nano standup.sh
# paste in the contents of this script - to save and exit the nano text editor:
# control x
# y
# return
# $ chmod +x standup.sh (this makes the script executable)
# $ ./standup.sh "insert pubkey" "insert node type (see options below)" "insert ssh key" "insert ssh allowed IP's" "insert password for standup user"

####
# 1. Set Initial Variables from command line arguments
####

# You can add 5 optional arguments when you run the script, like so:
# ./standup.sh "descriptor:x25519:NWJNEFU487H2BI3JFNKJENFKJWI3" "Pruned Mainnet" "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCedazNcEqvTmH/md2q04Y2qwbn7vh9HGh4Pw+cQEIX2DbW9VARAa2Nb8fZUMdvjF+kUS/TOtqeU+xGCsNR/RlLrR0HOmNUkFKb/4ZXd0sao16kT0QFExqiIYg/nxcpVVUjldGbtjwbaIg3PhviwktZlT37Rbg5eLRawleqNdDiHE1YkcfVraBbuz4DRf7eIgVN+3JQrbRPOgephrMZXmmKKGM9CxGI9b6TEa2R4c4aEBfPgpk3Trq70rX2Ubzm5/+OlwomA8N777XULll6DPoFQElorv49VXWl5pQGCIXj25v2Nf5dAqRLY88g79o08y36+3SUxGUAikfW00COb3I5 bob@mymac.local" "127.0.0.1, 192.086.443" "aPasswordForTheStandupUser"

# The variables are read as per below: ./standup.sh "PUBKEY" "BTCTYPE" "SSH_KEY" "SYS_SSH_IP" "USERPASSWORD"
# THE ORDER MATTERS, if you want to omit an argument then input empty qoutes in its place "" for example:
# ./standup "" "Pruned Testnet" "" "" "aPasswordForStandupUser"

# For Tor V3 client authentication (optional), you can run standup.sh like: ./standup.sh "descriptor:x25519:NWJNEFU487H2BI3JFNKJENFKJWI3"
# and it will automatically add the pubkey to the authorized_clients directory, which means the user is Tor authenticated before the
# node is even installed.
PUBKEY=$1

# Can be one of the following: "Mainnet", "Pruned Mainnet", "Testnet", "Pruned Testnet", or "Private Regtest", default is "Pruned Testnet"
BTCTYPE=$2

# Optional key for automated SSH logins to standup non-privileged account - if you do not want to add one add "" as an argument
SSH_KEY=$3

# Optional comma separated list of IPs that can use SSH - if you do not want to add any add "" as an argument
SYS_SSH_IP=$4

# Optional password for the standup non-privileged account - if you do not want to add one add "" as an argument
USERPASSWORD=$5

# Force check for root
if ! [ "$(id -u)" = 0 ]; then
  echo "You need to be logged in as root!"
  exit 1
fi

# Output stdout and stderr to ~root files
exec > >(tee -a /root/standup.log) 2> >(tee -a /root/standup.log /root/standup.err >&2)

####
# 2. Bring Debian Up To Date
####

echo "$0 - Starting Debian updates; this will take a while!"

# Make sure all packages are up-to-date

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

# Install haveged (a random number generator)

apt-get install haveged -y

# Set system to automatically update

echo "unattended-upgrades unattended-upgrades/enable_auto_updates boolean true" | debconf-set-selections
apt-get -y install unattended-upgrades

echo "$0 - Updated Debian Packages"

# get uncomplicated firewall and deny all incoming connections except SSH
sudo apt-get install ufw
ufw allow ssh
ufw enable

####
# 3. Set Up User
####

# Create "standup" user with optional password and give them sudo capability

/usr/sbin/useradd -m -p `perl -e 'printf("%s\n",crypt($ARGV[0],"password"))' "$USERPASSWORD"` -g sudo -s /bin/bash standup
/usr/sbin/adduser standup sudo

echo "$0 - Setup standup with sudo access."

# Set up SSH Key

if [ -n "$SSH_KEY" ]; then

   mkdir ~standup/.ssh
   echo "$SSH_KEY" >> ~standup/.ssh/authorized_keys
   chown -R standup ~standup/.ssh

   echo "$0 - Added .ssh key to standup."

fi

if [ -n "$SYS_SSH_IP" ]; then

  echo "sshd: $SYS_SSH_IP" >> /etc/hosts.allow
  echo "sshd: ALL" >> /etc/hosts.deny
  echo "$0 - Limited SSH access."

else

  echo "$0 - WARNING: Your SSH access is not limited; this is a major security hole!"

fi

####
# 4. Install latest stable tor
####

# Download tor

#  To use source lines with https:// in /etc/apt/sources.list the apt-transport-https package is required. Install it with:
sudo apt install apt-transport-https

# We need to set up our package repository before you can fetch Tor. First, you need to figure out the name of your distribution:
DEBIAN_VERSION=$(lsb_release -c | awk '{ print $2 }')

# You need to add the following entries to /etc/apt/sources.list:
cat >> /etc/apt/sources.list << EOF
deb https://deb.torproject.org/torproject.org $DEBIAN_VERSION main
deb-src https://deb.torproject.org/torproject.org $DEBIAN_VERSION main
EOF

# Then add the gpg key used to sign the packages by running:
sudo curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import
sudo gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

# Update system, install and run tor as a service
sudo apt update
sudo apt install tor deb.torproject.org-keyring

# Setup hidden service
sed -i -e 's/#ControlPort 9051/ControlPort 9051/g' /etc/tor/torrc
sed -i -e 's/#CookieAuthentication 1/CookieAuthentication 1/g' /etc/tor/torrc
sed -i -e 's/## address y:z./## address y:z.\
\
HiddenServiceDir \/var\/lib\/tor\/standup\/\
HiddenServiceVersion 3\
HiddenServicePort 1309 127.0.0.1:18332\
HiddenServicePort 1309 127.0.0.1:18443\
HiddenServicePort 1309 127.0.0.1:8332/g' /etc/tor/torrc
mkdir /var/lib/tor/standup
chown -R debian-tor:debian-tor /var/lib/tor/standup
chmod 700 /var/lib/tor/standup

# add V3 authorized_clients public key if one exists

if ! [ $PUBKEY == "" ]; then
  echo $PUBKEY > /var/lib/tor/standup/authorized_clients/fullynoded.auth
else
  echo "No Tor V3 authentication, anyone who gets access to your QR code can have full access to your node, ensure you do not store more then you are willing to lose and better yet use the node as a watch-only wallet"
fi

# Add standup to the tor group so that the tor authentication cookie can be read by bitcoind
sudo usermod -a -G debian-tor standup

# start tor and our hidden service
sudo systemctl restart tor

####
# 5. Install Bitcoin
####

# Download Bitcoin

echo "$0 - Downloading Bitcoin; this will also take a while!"

# CURRENT BITCOIN RELEASE:
# Change as necessary

export BITCOIN="bitcoin-core-0.19.0.1"

export BITCOINPLAIN=`echo $BITCOIN | sed 's/bitcoin-core/bitcoin/'`

sudo -u standup wget https://bitcoin.org/bin/$BITCOIN/$BITCOINPLAIN-x86_64-linux-gnu.tar.gz -O ~standup/$BITCOINPLAIN-x86_64-linux-gnu.tar.gz
sudo -u standup wget https://bitcoin.org/bin/$BITCOIN/SHA256SUMS.asc -O ~standup/SHA256SUMS.asc
sudo -u standup wget https://bitcoin.org/laanwj-releases.asc -O ~standup/laanwj-releases.asc

# Verifying Bitcoin: Signature

echo "$0 - Verifying Bitcoin."

sudo -u standup /usr/bin/gpg --no-tty --import ~standup/laanwj-releases.asc
export SHASIG=`sudo -u standup /usr/bin/gpg --no-tty --verify ~standup/SHA256SUMS.asc 2>&1 | grep "Good signature"`
echo "SHASIG is $SHASIG"

if [[ $SHASIG ]]; then
    echo "VERIFICATION SUCCESS / SIG: $SHASIG"
else
    (>&2 echo "VERIFICATION ERROR: Signature for Bitcoin did not verify!")
fi

# Verify Bitcoin: SHA

export TARSHA256=`/usr/bin/sha256sum ~standup/$BITCOINPLAIN-x86_64-linux-gnu.tar.gz | awk '{print $1}'`
export EXPECTEDSHA256=`cat ~standup/SHA256SUMS.asc | grep $BITCOINPLAIN-x86_64-linux-gnu.tar.gz | awk '{print $1}'`

if [ "$TARSHA256" == "$EXPECTEDSHA256" ]; then
   echo "VERIFICATION SUCCESS / SHA: $TARSHA256"
else
    (>&2 echo "VERIFICATION ERROR: SHA for Bitcoin did not match!")
fi

# Install Bitcoin

echo "$0 - Installinging Bitcoin."

sudo -u standup /bin/tar xzf ~standup/$BITCOINPLAIN-x86_64-linux-gnu.tar.gz -C ~standup
/usr/bin/install -m 0755 -o root -g root -t /usr/local/bin ~standup/$BITCOINPLAIN/bin/*
/bin/rm -rf ~standup/$BITCOINPLAIN/

# Start Up Bitcoin

echo "$0 - Configuring Bitcoin."

sudo -u standup /bin/mkdir ~standup/.bitcoin

# The only variation between Mainnet and Testnet is that Testnet has the "testnet=1" variable
# The only variation between Regular and Pruned is that Pruned has the "prune=550" variable, which is the smallest possible prune

RPCPASSWORD=$(xxd -l 16 -p /dev/urandom)

cat >> ~standup/.bitcoin/bitcoin.conf << EOF
server=1
dbcache=1536
par=1
maxuploadtarget=137
maxconnections=16
rpcuser=StandUp
rpcpassword=$RPCPASSWORD
rpcallowip=127.0.0.1
debug=tor
EOF

if [ "$BTCTYPE" == "" ]; then

BTCTYPE="Pruned Testnet"

fi

if [ "$BTCTYPE" == "Mainnet" ]; then

cat >> ~standup/.bitcoin/bitcoin.conf << EOF
txindex=1
EOF

elif [ "$BTCTYPE" == "Pruned Mainnet" ]; then

cat >> ~standup/.bitcoin/bitcoin.conf << EOF
prune=550
EOF

elif [ "$BTCTYPE" == "Testnet" ]; then

cat >> ~standup/.bitcoin/bitcoin.conf << EOF
txindex=1
testnet=1
EOF

elif [ "$BTCTYPE" == "Pruned Testnet" ]; then

cat >> ~standup/.bitcoin/bitcoin.conf << EOF
prune=550
testnet=1
EOF

elif [ "$BTCTYPE" == "Private Regtest" ]; then

cat >> ~standup/.bitcoin/bitcoin.conf << EOF
regtest=1
txindex=1
EOF

else

  (>&2 echo "$0 - ERROR: Somehow you managed to select no Bitcoin Installation Type, so Bitcoin hasn't been properly setup. Whoops!")
  exit 1

fi

cat >> ~standup/.bitcoin/bitcoin.conf << EOF
[test]
rpcbind=127.0.0.1
rpcport=18332
[main]
rpcbind=127.0.0.1
rpcport=8332
[regtest]
rpcbind=127.0.0.1
rpcport=18443
EOF

/bin/chown standup ~standup/.bitcoin/bitcoin.conf
/bin/chmod 600 ~standup/.bitcoin/bitcoin.conf

# Setup bitcoind as a service that requires Tor
echo "$0 - Setting up Bitcoin as a systemd service."

sudo cat > /etc/systemd/system/bitcoind.service << EOF
# It is not recommended to modify this file in-place, because it will
# be overwritten during package upgrades. If you want to add further
# options or overwrite existing ones then use
# $ systemctl edit bitcoind.service
# See "man systemd.service" for details.

# Note that almost all daemon options could be specified in
# /etc/bitcoin/bitcoin.conf, except for those explicitly specified as arguments
# in ExecStart=

[Unit]
Description=Bitcoin daemon
After=tor.service
Requires=tor.service

[Service]
ExecStart=/usr/local/bin/bitcoind -conf=/home/standup/.bitcoin/bitcoin.conf

# Process management
####################
Type=simple
PIDFile=/run/bitcoind/bitcoind.pid
Restart=on-failure

# Directory creation and permissions
####################################

# Run as bitcoin:bitcoin
User=standup
Group=sudo

# /run/bitcoind
RuntimeDirectory=bitcoind
RuntimeDirectoryMode=0710

# Hardening measures
####################

# Provide a private /tmp and /var/tmp.
PrivateTmp=true

# Mount /usr, /boot/ and /etc read-only for the process.
ProtectSystem=full

# Disallow the process and all of its children to gain
# new privileges through execve().
NoNewPrivileges=true

# Use a new /dev namespace only populated with API pseudo devices
# such as /dev/null, /dev/zero and /dev/random.
PrivateDevices=true

# Deny the creation of writable and executable memory mappings.
MemoryDenyWriteExecute=true

[Install]
WantedBy=multi-user.target

EOF

echo "$0 - Starting bitcoind service"
sudo systemctl enable bitcoind.service
sudo systemctl start bitcoind.service

####
# 6. Install QR encoder and displayer, and show the btcstandup:// uri in plain text incase the QR Code does not display
####

# Get the Tor onion address for the QR code
HS_HOSTNAME=$(sudo cat /var/lib/tor/standup/hostname)

# Create the QR string
QR="btcstandup://StandUp:$RPCPASSWORD@$HS_HOSTNAME:1309/?label=StandUp.sh"
echo "Ready to display the QuickConnect QR, first we need to install qrencode and fim"

# Get software packages for encoding a QR code and displaying it in a terminal
sudo apt-get install qrencode
sudo apt-get install fim

# Create the QR
qrencode -m 10 -o qrcode.png "$QR"

# Display the QR code
fim -a qrcode.png

# Display the text incase QR code does not work
echo "********************************************"
echo "This is your btcstandup:// uri to convert into a QR that you can scan with FullyNoded (incase the actual QR did not display):"
echo $QR
echo "********************************************"
echo "Bitcoin is setup as a service and will automatically start if your VPS reboots and so is Tor"
echo "You can manually stop Bitcoin with: sudo systemctl stop bitcoind.service"
echo "You can manually start Bitcoin with: sudo systemctl start bitcoind.service"

# Finished, exit script
exit 1
