#!/bin/bash
. "$(dirname $0)/../install-reuse.sh"
READER=$(selectMicroSD)
diskcopy /home/petrum/Downloads/2016-03-18-raspbian-jessie.img $READER
#diskcopy /home/petrum/Downloads/2016-03-18-raspbian-jessie-lite.img $READER
expandFS $READER
BOOT=$(mountFS $READER 1)
enable_spi $BOOT
umountFS $BOOT
DEST=$(mountFS $READER 2)
sethostname weather $DEST
get_rpi $DEST
get_MAX7219array $DEST
#autostart_MAX7219array_demo $DEST
sudo sed -i 's|^exit 0|cd /home/pi/git/rpi/weather; ./weather.sh\nexit 0|g' $DEST/etc/rc.local
umountFS $DEST
