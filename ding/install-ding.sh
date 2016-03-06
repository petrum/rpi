#!/bin/bash

. install-reuse.sh

READER=$(selectMicroSD)
diskcopy /home/petrum/Downloads/2015-11-21-raspbian-jessie.img $READER
#diskcopy /home/petrum/Downloads/ubuntu-15.04-snappy-armhf-raspi2.img $READER
#diskcopy /home/petrum/Downloads/ubuntu-mate-15.10.3-desktop-armhf-raspberry-pi-2.img $READER
#exit 0
expandFS $READER
#exit 0
DEST=$(mountFS $READER)
#echo $DEST
aptget $DEST
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/rpi-zero
networkSetup $SRC $DEST
sethostname dinger $DEST
pigpioInstall $DEST/home/pi/pigpio $DEST/home/pi/setup.sh
get-rpi /home/petrum/rpi/motion $DEST
cat <<EOF >> $DEST/home/pi/setup.sh
cd
sudo cp git/rpi/motion/cfg/etc/rc.local /etc/rc.local
sudo reboot
EOF
cat $DEST/home/pi/setup.sh
umountFS $DEST

