#!/bin/bash
LOG=/root/setup.log

DISPLAY=/home/pi/git/rpi/weather/display.py

$DISPLAY connect please wait...
ip=$(hostname -I) || true
if [ ! "$ip" ]; then
    $DISPLAY No IP
    exit 1
fi
$DISPLAY 'IP ='
echo $ip | $DISPLAY

$DISPLAY git upgrade please wait...
cd /home/pi/git/rpi
git pull
if [[ -f /root/setup.done ]] ; then
    $DISPLAY all looks fine already
    exit 0
fi
$DISPLAY update please wait...
if ! apt-get update --fix-missing >> $LOG 2>&1 ; then
   $DISPLAY failed to update
   exit 2
fi
$DISPLAY done
$DISPLAY install please wait...
if ! apt-get install python-pip python-dev vim git -y >> $LOG 2>&1 ; then
    $DISPLAY failed to install
    exit 3
fi
$DISPLAY done
$DISPLAY pip install spidev please wait...
if ! pip install spidev >> $LOG 2>&1 ; then
    $DISPLAY failed to install spidev
    exit 3
fi
 
$DISPLAY setup done
touch /root/setup.done
exit 0

