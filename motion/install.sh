#!/bin/bash
. "$(dirname $0)/../install-reuse.sh"
READER=$(selectMicroSD)
diskcopy /home/petrum/Downloads/2016-03-18-raspbian-jessie-lite.img $READER
expandFS $READER
DEST=$(mountFS $READER 2)
networkSetup ~/github/rpi/net $DEST
sethostname motion $DEST
get-rpi ~/github/rpi $DEST
SETUP=$DEST/home/pi/setup.sh
cat << EOF > $SETUP
sudo apt-get install tmux vim -y
crontab < git/rpi/motion/cfg/crontab
echo | ssh-keygen -t rsa -N ''
ssh-copy-id petrum@192.168.1.5
echo reboot
sudo reboot
EOF
chmod a+x $SETUP
cat $SETUP
umountFS $DEST

