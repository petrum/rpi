#!/bin/bash
. "$(dirname $0)/../install-reuse.sh"
READER=$(selectMicroSD)
diskcopy /home/petrum/raspbian.img/2016-09-23-raspbian-jessie-lite.img $READER
DEST=$(mountFS $READER 2)
generic_setup $DEST $READER
static_ip '10.0.0.30' '10.0.0.1' $DEST
sethostname dinger $DEST
umountFS $DEST

