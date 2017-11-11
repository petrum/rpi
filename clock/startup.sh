#!/bin/bash
cd /home/pi/git/rpi/clock

echo "Started at " $(date)
while ! /bin/bash ./setup.sh ; do
    echo 'Sleeping 5 sec...'
    sleep 5
done
echo "Done at " $(date)
sync
while :
do
    #cat /home/pi/clock.txt | /home/pi/git/rpi/clock/display.py
    #sleep 1
done

