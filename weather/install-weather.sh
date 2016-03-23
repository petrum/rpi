#!/bin/bash
. "$(dirname $0)/../install-reuse.sh"
READER=$(selectMicroSD)
diskcopy /home/petrum/Downloads/2016-03-18-raspbian-jessie-lite.img $READER
expandFS $READER
DEST=$(mountFS $READER)
networkSetup ~/github/rpi/net $DEST
sethostname weather $DEST
get-rpi ~/github/rpi $DEST
enable_spi $DEST
get_MAX7219array $DEST
autostart_MAX7219array_demo $DEST
umountFS $DEST

