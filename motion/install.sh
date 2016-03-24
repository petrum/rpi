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
SETUP=$DEST/home/pi/setup.sh
cat << EOF > $SETUP
echo | ssh-keygen -t rsa -N ''
ssh-copy-id petrum@192.168.1.5
EOF
chmod a+x $SETUP
cat $SETUP
umountFS $DEST
