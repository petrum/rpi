#!/bin/bash
. "$(dirname $0)/../install-reuse.sh"
READER=$(selectMicroSD)
#diskcopy /home/petrum/Downloads/2016-03-18-raspbian-jessie.img $READER
diskcopy /home/petrum/Downloads/2016-03-18-raspbian-jessie-lite.img $READER
expandFS $READER
DEST=$(mountFS $READER 2)
generic_setup $DEST
static_ip '192.168.1.8' '192.168.1.1' $DEST
sethostname dinger $DEST
get_rpi $DEST
umountFS $DEST

