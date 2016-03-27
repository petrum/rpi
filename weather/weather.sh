#!/bin/bash

crontab -u pi < crontab
PYTHONPATH=/home/pi/MAX7219array "$(dirname $0)"/display.py /home/pi/weather.txt

