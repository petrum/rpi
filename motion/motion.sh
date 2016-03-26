#!/bin/bash

while ! /home/pi/git/rpi/motion/setup.sh ; do
    sleep 5
done
HOST=$(hostname)
IP=$(hostname -I)
date | mail -s "Motion started on $HOST using $IP" petru.marginean@gmail.com
/home/pi/git/rpi/motion/motion.py
