#!/bin/bash
echo "Started at " $(date)
while ! /bin/bash /home/pi/git/rpi/motion/setup.sh ; do
    echo 'Sleeping 5 sec...'
    sleep 5
done
echo "Done at " $(date)
HOST=$(hostname)
IP=$(hostname -I)
(date; echo "$HOST $IP") | mail -s "RPI motion started" petru.marginean@gmail.com
/home/pi/git/rpi/motion/motion.py
