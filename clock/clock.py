#!/usr/bin/env python

import max7219.led as led
import max7219.font as font
import sys
import time
import fileinput
import socket
import datetime

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

def replace(s, i, c):
    return s[0:i] + c + s[i + 1:]

def isNight(t):
    return t >= '20:00:00' or t <= '07:00:00'

def aboutOpen(t):
    return t >= '09:29:50' and t <= '09:30:00'

def aboutClose(t):
    return t >= '15:59:50' and t <= '16:00:00'

def setBrigthness(t):
    device.brightness(0 if isNight(t) else 3)

def onTheMinute(t):
    return t[-2:] == '00'

def breathing(s, b):
    n = b % 9
    if n == 0:
        s = replace(s, 2, ' ') #__
        s = replace(s, 5, ' ')
        return s
    if n == 1:
        s = replace(s, 2, '.') #._
        s = replace(s, 5, ' ')
        return s
    if n == 2:
        s = replace(s, 2, ':') #:_
        s = replace(s, 5, ' ')
        return s
    if n == 3:
        s = replace(s, 2, ':') #:.
        s = replace(s, 5, '.')
        return s
    if n == 4:
        s = replace(s, 2, ':') #::
        s = replace(s, 5, ':')
        return s
    if n == 5:
        s = replace(s, 2, ':') #:.
        s = replace(s, 5, '.')
        return s
    if n == 6:
        s = replace(s, 2, ':') #:_
        s = replace(s, 5, ' ')
        return s
    if n == 7:
        s = replace(s, 2, '.') #._
        s = replace(s, 5, ' ')
        return s
    if n == 8:
        s = replace(s, 2, ' ') #__
        s = replace(s, 5, ' ')
        return s
    return s

sys.path.insert(0, '..')

device = led.matrix(cascaded=8)
device.orientation(90)
device.brightness(3)

isConnected = is_connected()
last = ''
while True:
    time.sleep(.05)
    t = datetime.datetime.now().strftime('%H:%M:%S')
    if last == t:
        continue

    breath = int(datetime.datetime.now().strftime('%s'))
    device.invert(aboutOpen(t) or aboutClose(t))
    #device.brightness(int(t[-1])) # experimenting
    if onTheMinute(t):
        isConnected = is_connected()
        setBrigthness(t)

    t = breathing(t, breath)
    if not isConnected:
        t = replace(t, 5, ';')

    #print t
    device.show_message(t, delay=0)
    last = t
