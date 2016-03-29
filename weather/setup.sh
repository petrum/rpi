#!/bin/bash
LOG=/root/setup.log
/home/pi/git/rpi/weather/display.py Started
ip=$(hostname -I) || true
if [ ! "$ip" ]; then
    /home/pi/git/rpi/weather/display.py No IP
    exit 1
fi
/home/pi/git/rpi/weather/display.py 'IP ='
echo $ip | /home/pi/git/rpi/weather/display.py
if [[ -f /root/setup.done ]] ; then
    /home/pi/git/rpi/weather/display.py Everything looks fine already
    exit 0
fi
/home/pi/git/rpi/weather/display.py Updating please wait
if ! apt-get update --fix-missing >> $LOG 2>&1 ; then
   /home/pi/git/rpi/weather/display.py Failed to update
   exit 2
fi
/home/pi/git/rpi/weather/display.py done
/home/pi/git/rpi/weather/display.py Installing please wait
if ! apt-get install python-pip python-dev vim -y >> $LOG 2>&1 ; then
    /home/pi/git/rpi/weather/display.py Failed to install
    exit 3
fi
/home/pi/git/rpi/weather/display.py done
/home/pi/git/rpi/weather/display.py pip installing spidev please wait
if ! pip install spidev >> $LOG 2>&1 ; then
    /home/pi/git/rpi/weather/display.py Failed to install spidev
    exit 3
fi
/home/pi/git/rpi/weather/display.py done all
touch /root/setup.done
/home/pi/git/rpi/weather/display.py All setup
exit 0

