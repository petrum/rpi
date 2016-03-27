#!/bin/bash

crontab -u pi crontab

echo "Started at " $(date)
while ! /bin/bash /home/pi/git/rpi/weather/setup.sh ; do
    echo 'Sleeping 5 sec...'
    sleep 5
done
echo "Done at " $(date)

PYTHONPATH=/home/pi/MAX7219array "$(dirname $0)"/display.py /home/pi/weather.txt

