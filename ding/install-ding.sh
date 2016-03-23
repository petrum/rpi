#!/bin/bash
. "$(dirname $0)/../install-reuse.sh"
READER=$(selectMicroSD)
diskcopy /home/petrum/Downloads/2016-03-18-raspbian-jessie-lite.img $READER
expandFS $READER
DEST=$(mountFS $READER)
networkSetup ~/github/rpi/net $DEST
sethostname dinger $DEST
get-rpi ~/github/rpi $DEST
umountFS $DEST

