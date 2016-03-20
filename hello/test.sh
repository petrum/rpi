#!/bin/bash

make -C /lib/modules/$(uname -r)/build M=$(pwd) modules
sudo insmod hello.ko
dmesg | tail -1
#[58728.008906] Hello World :)
sudo rmmod hello
dmesg | tail -1
#[58732.440677] Goodbye World!

