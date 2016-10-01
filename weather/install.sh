#!/bin/bash
. "$(dirname $0)/../install-reuse.sh"
READER=$(selectMicroSD)
diskcopy /home/petrum/Downloads/2016-09-23-raspbian-jessie-lite.img $READER
enable_spi
DEST=$(mountFS $READER 2)
generic_setup $DEST $READER
dynamic_ip 192.168.1.1 255.255.255.0 $DEST 
sethostname weather $DEST
get_MAX7219array $DEST 7
sudo sed -i 's|^exit 0|/home/pi/git/rpi/weather/startup.sh >> /root/weather.log 2>\&1\nexit 0|g' $DEST/etc/rc.local
umountFS $DEST
