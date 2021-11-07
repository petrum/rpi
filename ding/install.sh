#!/bin/bash
. "$(dirname $0)/../install-reuse.sh"
READER=$(selectMicroSD)
diskcopy /home/petrum/raspbian.img/2017-09-07-raspbian-stretch-lite.img $READER
DEST=$(mountFS $READER 2)
generic_setup $DEST $READER
#static_ip '10.0.0.30' '10.0.0.1' $DEST
dynamic_ip 10.0.0.1 255.255.255.0 $DEST
sethostname dinger $DEST
umountFS $DEST

