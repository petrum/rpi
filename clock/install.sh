#!/bin/bash
set -e

. "$(dirname $0)/../install-reuse.sh"
READER=$(selectMicroSD)
#diskcopy /home/petrum/Downloads/2016-09-23-raspbian-jessie-lite.img $READER
diskcopy /home/petrum/raspbian.img/2017-09-07-raspbian-stretch-lite.img $READER
enable_spi
DEST=$(mountFS $READER 2)
generic_setup $DEST $READER 

dynamic_ip 192.168.1.1 255.255.255.0 $DEST 
sethostname clock $DEST
get_max7219 $DEST
sudo sed -i 's|^exit 0|/home/pi/git/rpi/clock/startup.sh >> /root/clock.log 2>\&1\nexit 0|g' $DEST/etc/rc.local
umountFS $DEST

