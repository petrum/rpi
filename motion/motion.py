#!/usr/bin/python

import time
import datetime
import os
import RPi.GPIO as GPIO
import socket

#PIR Sensor(#555-28027)
#https://www.parallax.com/sites/default/files/downloads/555-28027-PIR-Sensor-Product-Guide-v2.3.pdf

## Raspberry Pi 2 Model B (J8 header)
# 3.3 VDC 1  o    o 2 5.0 VDC (Power) <======
#         3  o    o 4 5.0 VDC
#         5  o    o 6 Ground
#         7  o    o 8
# GND     9  o    o 10
# GEN017 11  o    o 12
# GEN027 13  o    o 14
#            o    o 16 GPIO 23 
#            o    o 18 GPIO 24 
#            o    o

GPIO.setmode(GPIO.BCM)
pir = 27
GPIO.setup(pir, GPIO.IN)

def alarm():
    ts = time.time()
    global last
    if ts - last > 30:
        last = ts
        st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
        result = os.system("echo PIR motion detection at " + st + " | ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no petrum@192.168.1.5 mail -s 'motion detected on " + socket.gethostname() + "' petru.marginean@gmail.com")
        print(st, "PIR ALARM!")

last = 0
while True:
    if GPIO.input(pir):
        alarm()

GPIO.cleanup()

