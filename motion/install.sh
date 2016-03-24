#!/bin/bash
. "$(dirname $0)/../install-reuse.sh"
READER=$(selectMicroSD)
#diskcopy /home/petrum/Downloads/2016-03-18-raspbian-jessie.img $READER
diskcopy /home/petrum/Downloads/2016-03-18-raspbian-jessie-lite.img $READER
expandFS $READER
DEST=$(mountFS $READER 2)
networkSetup ~/github/rpi/net $DEST
sethostname motion $DEST
get_rpi $DEST
sudo sed -i 's|^exit 0|/home/pi/git/rpi/motion/motion.py > /tmp/motion.log 2>\&1\nexit 0|g' $1/etc/rc.local
sudo mkdir $DEST/root/.ssh
sudo cp /home/petrum/rpi-private/id_rsa $DEST/root/.ssh
umountFS $DEST
