#!/usr/bin/python

import time
import pigpio
import datetime
import os
from time import sleep

pi = pigpio.pi()
pir_pin = 27

#PIR Sensor(#555-28027)
#https://www.parallax.com/sites/default/files/downloads/555-28027-PIR-Sensor-Product-Guide-v2.3.pdf

## Raspberry Pi 2 Model B (J8 header)
#+3.3 VDC o    o 2 +5.0 VDC (Power)
#         o    o 4 +5.0 VDC  <===== VCC
#         o    o 6 Ground   <===== GND
#         o    o 8
#         o    o 10
#         o    o 12
#         o    o 14
#         o    o 16 GPIO 23  <==== Out
#         o    o 18 GPIO 24 
#         o    o

def alarm():
    ts = time.time()
    global last
    if ts - last > 30:
        last = ts
        st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
        result = os.system("echo PIR motion detection at " + st + " | ssh petrum@192.168.1.5 mail -s 'motion detected' petru.marginean@gmail.com")
        print(st, "PIR ALARM!")

last = 0
while True:
    if pi.read(pir_pin):
        alarm()
    time.sleep(1)
