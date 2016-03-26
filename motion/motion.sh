#!/bin/bash

while ! /home/pi/git/rpi/motion/setup.sh ; then
do
    sleep 5
done
/home/pi/git/rpi/motion/motion.py
