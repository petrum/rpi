#!/usr/bin/env python

import max7219.led as led
import max7219.font as font
import sys
import time
import fileinput
import datetime
import socket

REMOTE_SERVER = "www.google.com"
def is_connected():
  return True
  try:
    host = socket.gethostbyname(REMOTE_SERVER)
    s = socket.create_connection((host, 80), 2)
    s.close()
    return True
  except:
     pass
  return False

sys.path.insert(0, '..')

device = led.matrix(cascaded=8)
device.orientation(90)
device.brightness(3)

isConnected = is_connected()
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
        isConnected = is_connected()
    if not isConnected:
        if t[-1:] == '0':
            isConnected = is_connected()
            t = t.replace(':', ';')
    device.invert(inverted)
    #print t
    device.show_message(t, delay=0)
    last = t

