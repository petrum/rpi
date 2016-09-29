#!/bin/bash
. "$(dirname $0)/../install-reuse.sh"
READER=$(selectMicroSD)
diskcopy /home/petrum/Downloads/2016-03-18-raspbian-jessie-lite.img $READER
expandFS $READER
BOOT=$(mountFS $READER 1)
enable_spi $BOOT
umountFS $BOOT
DEST=$(mountFS $READER 2)
generic_setup $DEST
dynamic_ip 192.168.1.1 255.255.255.0 $DEST 
sethostname weather $DEST
get_max7219 DEST 7
sudo sed -i 's|^exit 0|/home/pi/git/rpi/weather2/startup.sh >> /root/weather.log 2>\&1\nexit 0|g' $DEST/etc/rc.local
umountFS $DEST

