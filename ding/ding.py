#!/usr/bin/python

import time
import pigpio
import datetime
import os
from time import sleep

pi = pigpio.pi()
data = 17

## Raspberry Pi 2 Model B (J8 header)
# 3.3 VDC o    o 2 5.0 VDC (Power) <======
#         o    o 4 5.0 VDC
#         o    o 6 Ground
#         o    o 8
# GND     o    o 10
# GEN0 17 o    o 12
#         o    o 14
#         o    o 16 GPIO 23 
#         o    o 18 GPIO 24 
#         o    o

def micro_sleep(microsec):
    m = 1000000
    end = time.time() * m + microsec
    count = 0
    while True:
        count += 1
        if time.time() * m >= end:
            print microsec, count
            return

def ding(bits):
    #print 'There are', len(bits), "bits"	
    for i, b in enumerate(bits):
        pi.write(data, 0)
        if b == '0':
            micro_sleep(700)
            pi.write(data, 1)
            micro_sleep(300)
        else:
            micro_sleep(400)
            pi.write(data, 1)
            micro_sleep(600)
        pi.write(data, 0)
        #print i, b

start = time.time() * 1000000
for i in range(10):
    micro_sleep(1000 * 20)
    ding("0000001110111")

print "total:", time.time() * 1000000 - start

