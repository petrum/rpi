#!/bin/bash
/home/pi/git/rpi/weather/display.py Started
ip=$(hostname -I) || true
if [ ! "$ip" ]; then
    /home/pi/git/rpi/weather/display.py No IP
    exit 1
fi
/home/pi/git/rpi/weather/display.py 'IP =' $ip
if [[ -f /root/setup.done ]] ; then
    /home/pi/git/rpi/weather/display.py Everything looks fine already
    exit 0
fi
/home/pi/git/rpi/weather/display.py Updating
if ! apt-get update --fix-missing >/dev/null 2>&1 ; then
   /home/pi/git/rpi/weather/display.py Failed to update
   exit 2
fi
/home/pi/git/rpi/weather/display.py done
/home/pi/git/rpi/weather/display.py Installing
if ! apt-get install python-pip python-dev vim -y >/dev/null 2>&1 ; then
    /home/pi/git/rpi/weather/display.py Failed to install
    exit 3
fi
/home/pi/git/rpi/weather/display.py done
/home/pi/git/rpi/weather/display.py pip installing spidev
if ! pip install spidev >/dev/null 2>&1 ; then
    /home/pi/git/rpi/weather/display.py Failed to install spidev
    exit 3
fi
/home/pi/git/rpi/weather/display.py done

touch /root/setup.done
/home/pi/git/rpi/weather/display.py All setup
exit 0

