#!/bin/bash
cd /home/pi/git/rpi/weather
export PYTHONPATH=/home/pi/MAX7219array

echo "Started at " $(date)
while ! /bin/bash ./setup.sh ; do
    echo 'Sleeping 5 sec...'
    sleep 5
done
echo "Done at " $(date)
sync
crontab -u pi crontab
while :
do
    cat /home/pi/weather.txt | /home/pi/git/rpi/weather/display.py
    sleep 1
done

