#!/bin/bash
echo "Started at " $(date)
cd /home/pi/git/rpi/motion
while ! /bin/bash ./setup.sh ; do
    echo 'Sleeping 5 sec...'
    sleep 5
done
echo "Done at " $(date)
HOST=$(hostname)
IP=$(hostname -I)
(date; echo "$HOST $IP") | mail -s "RPI motion started" "$@"
sync
./motion.py "$@"

