#!/bin/bash
cd /home/pi/git/rpi/clock

echo "Started at " $(date)
while ! /bin/bash ./setup.sh ; do
    echo 'Sleeping 5 sec...'
    sleep 5
done
echo "Done at " $(date)
sync
/home/pi/git/rpi/clock/clock.py

