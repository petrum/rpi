#!/bin/bash

LOG=/root/setup.log
date >> $LOG
ip=$(hostname -I) || true
if [ ! "$ip" ]; then
    echo "No IP..."
    exit 1
fi
echo "IP = $ip"

DONE=/root/setup.done

if [[ -f $DONE ]]; then
    echo "Everything looks fine already..."
    exit 0
fi
if ! apt-get update --fix-missing >> $LOG 2>&1 ; then
   echo 'Failed to update...'
   exit 2
fi
   
if ! apt-get install ssmtp mailutils vim -y >> $LOG 2>&1 ; then
    echo 'Failed to install...'
    exit 3
fi
if ! cat /home/pi/ssmtp.conf >> /etc/ssmtp/ssmtp.conf ; then
    echo 'Failed to add credentials...'
    exit 4
fi
echo 'All setup'
touch $DONE
exit 0
