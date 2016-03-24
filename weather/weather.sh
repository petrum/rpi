#!/bin/bash

if [[ ! -e '/tmp/weather.txt' ]]; then
    echo 'Nothing yet' > '/tmp/weather.txt'
fi

PYTHONPATH=/home/pi/MAX7219array "$(dirname $0)"/weather.py

