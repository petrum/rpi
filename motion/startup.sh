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
(echo -e "Subject: RPI motion started\r\n\r\n"; date; echo "$HOST $IP") | /usr/bin/msmtp "$@"
sync
./motion.py "$@" >> /home/pi/motion.log 2>&1

