#!/bin/bash

/usr/bin/raspi-config nonint do_boot_wait 0

LOG=/root/motion-setup.log
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

if ! apt-get install msmtp vim -y >> $LOG 2>&1 ; then
    echo 'Failed to install...'
    exit 3
fi
if ! cat /home/pi/msmtprc >> /etc/msmtprc ; then
    echo 'Failed to copy msmtprc file...'
    exit 4
fi

echo -e "Subject: motion setup from $ip\r\n\r\nThe setup is complete" | /usr/bin/msmtp petru.marginean@gmail.com

echo 'All setup'
touch $DONE
exit 0
