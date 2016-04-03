#!/usr/bin/python

import time
import RPi.GPIO as GPIO

## Raspberry Pi 2 Model B (J8 header)
# 3.3 VDC 1  o    o 2 5.0 VDC (Power) <======
#         3  o    o 4 5.0 VDC
#         5  o    o 6 Ground
#         7  o    o 8
# GND     9  o    o 10
# GEN017 11  o    o 12
#            o    o 14
#            o    o 16 GPIO 23 
#            o    o 18 GPIO 24 
#            o    o

data = 17
GPIO.setmode(GPIO.BCM)
GPIO.setup(data, GPIO.OUT)

def micro_sleep(microsec):
    m = 1000000
    end = time.time() * m + microsec
    count = 0
    while True:
        count += 1
        if time.time() * m >= end:
            #print microsec, count
            return

def set(d, b):
    GPIO.output(d, False)
    if b == '0':
        micro_sleep(700)
        GPIO.output(d, True)
        micro_sleep(300)
    else:
        micro_sleep(400)
        GPIO.output(d, True)
        micro_sleep(600)
    GPIO.output(d, False)

def ding(bits):
    #print 'There are', len(bits), "bits"	
    for i, b in enumerate(bits):
        set(data, b)

start = time.time() * 1000000
for i in range(10):
    micro_sleep(1000 * 20)
    ding("0000001110111")

print "total:", time.time() * 1000000 - start, 'microsec'

GPIO.cleanup()
