#!/usr/bin/env python

import max7219.led as led
import max7219.font as font
import sys
import time
import fileinput
import datetime

sys.path.insert(0, '..')
import connected

device = led.matrix(cascaded=8)
device.orientation(90)
device.brightness(3)

isConnected = connected.test()
last = ''
inverted = False
while True:
    time.sleep(.05)
    t = datetime.datetime.now().strftime('%H:%M:%S')
    if last == t:
        continue
    if (t > '09:29:50' and t < '09:30:00') or (t > '15:59:50' and t < '16:00:00'):
        inverted = not inverted
    else:
        inverted = False

    if t[-2:] == '00':
        isConnected = connected.test()
    if not isConnected:
        t = t.replace(':', ';')
        
    #device.invert(inverted)
    #print t
    device.show_message(t, delay=0)
    last = t

