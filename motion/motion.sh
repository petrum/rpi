#!/bin/bash

while ! /bin/bash /home/pi/git/rpi/motion/setup.sh ; do
    sleep 5
done
HOST=$(hostname)
IP=$(hostname -I)
(date; echo "$HOST $IP") | mail -s "Motion started" petru.marginean@gmail.com
/home/pi/git/rpi/motion/motion.py
