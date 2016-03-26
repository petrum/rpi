#!/bin/bash

ip=$(hostname -I) || true
if [ ! "$ip" ]; then
    echo "No IP..."
    exit 1
fi
echo "IP = $ip"
if grep --quiet AuthUser /etc/ssmtp/ssmtp.conf; then
    echo "Everything looks fine already..."
    exit 0
fi
if ! apt-get update --fix-missing >/dev/null 2>&1 ; then
   echo 'Failed to update...'
   exit 2
fi
   
if ! apt-get install ssmtp mailutils vim -y >/dev/null 2>&1 ; then
    echo 'Failed to install...'
    exit 3
fi
if ! cat /home/pi/ssmtp.conf >> /etc/ssmtp/ssmtp.conf ; then
    echo 'Failed to add credentials...'
    exit 4
fi
echo 'All setup'
exit 0
