#!/usr/bin/env python
import MAX7219array as m7219
from MAX7219fonts import CP437_FONT, SINCLAIRS_FONT, LCD_FONT, TINY_FONT
from MAX7219array import DIR_L, DIR_R, DIR_U, DIR_D
import sys
import time

f = sys.argv[1]

def get_weather_forever():
    while True:
        try:
            fh = open(f, 'r')
            display(fh.read().splitlines())
            fh.close()
        except Exception as e:
            display(["ERROR: " + repr(e)])
        time.sleep(1)

def display(s):    
    for line in s:
        m7219.init()
        m7219.brightness(7)
        m7219.scroll_message_horiz(line, 1, 5.5, DIR_L, CP437_FONT)
        m7219.clear_all()
        #print(line)

get_weather_forever()

