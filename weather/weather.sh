#!/bin/bash

if [[ ! -e '/tmp/weather.txt' ]]; then
    echo 'Nothing yet' > '/tmp/weather.txt'
fi

crontab -u pi < crontab
PYTHONPATH=/home/pi/MAX7219array "$(dirname $0)"/display.py /home/pi/weather.txt

