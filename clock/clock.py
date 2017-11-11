#!/usr/bin/env python

import max7219.led as led
import max7219.font as font
import sys
import time
import fileinput
import datetime

device = led.matrix(cascaded=8)
device.orientation(90)
device.brightness(3)

while True:
    device.show_message(datetime.datetime.now().strftime('%H:%M:%S'), delay=0)

