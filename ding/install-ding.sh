#!/bin/bash
. "$(dirname $0)/../install-reuse.sh"
READER=$(selectMicroSD)
diskcopy /home/petrum/Downloads/2015-11-21-raspbian-jessie.img $READER
expandFS $READER
DEST=$(mountFS $READER)
aptget $DEST
networkSetup ~/github/rpi/net $DEST
sethostname dinger $DEST
pigpioInstall $DEST/home/pi/pigpio $DEST/home/pi/setup.sh
get-rpi ~/github/rpi $DEST
cat <<EOF >> $DEST/home/pi/setup.sh
sudo reboot
EOF
cat $DEST/home/pi/setup.sh
umountFS $DEST

