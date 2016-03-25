#!/bin/bash
. "$(dirname $0)/../install-reuse.sh"
READER=$(selectMicroSD)
#diskcopy /home/petrum/Downloads/2016-03-18-raspbian-jessie.img $READER
diskcopy /home/petrum/Downloads/2016-03-18-raspbian-jessie-lite.img $READER
expandFS $READER
DEST=$(mountFS $READER 2)
sethostname motion $DEST
get_rpi $DEST
sudo sed -i 's|^exit 0|/home/pi/git/rpi/motion/motion.py >> /tmp/motion.log 2>\&1\nexit 0|g' $DEST/etc/rc.local
sudo mkdir -p $DEST/root/.ssh
sudo cp -v /home/petrum/rpi-private/id_rsa $DEST/root/.ssh
sudo chmod 600 $DEST/root/.ssh/id_rsa
sudo ls -ltr $DEST/root/.ssh/id_rsa
umountFS $DEST
