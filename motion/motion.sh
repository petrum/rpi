#!/bin/bash
echo "Started at " $(date)
while ! /bin/bash /home/pi/git/rpi/motion/setup.sh ; do
    echo -e '.'
    sleep 5
done
echo "Done at " $(date)
HOST=$(hostname)
IP=$(hostname -I)
(date; echo "$HOST $IP") | mail -s "Motion started" petru.marginean@gmail.com
/home/pi/git/rpi/motion/motion.py
