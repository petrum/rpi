#!/bin/bash
. "$(dirname $0)/../install-reuse.sh"
READER=$(selectMicroSD)
diskcopy /home/petrum/Downloads/2016-03-18-raspbian-jessie-lite.img $READER
expandFS $READER
DEST=$(mountFS $READER)
networkSetup ~/github/rpi/net $DEST
sethostname motion $DEST
get-rpi ~/github/rpi $DEST
cat << EOF > $DEST/home/pi/setup.sh
sudo apt-get install tmux vim -y
cd
crontab < git/rpi/motion/cfg/crontab
echo | ssh-keygen -t rsa -N ''
ssh-copy-id petrum@192.168.1.5
echo reboot
sudo reboot
EOF
chmod a+x $DEST/home/pi/setup.sh
umountFS $DEST

