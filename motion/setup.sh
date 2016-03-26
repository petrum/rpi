#!/bin/bash

ip=$(hostname -I) || true
if [ ! "$ip" ]; then
    echo "No IP..." 1>&2
    exit 1
fi
echo "IP = $ip"
if grep --quiet AuthUser /etc/ssmtp/ssmtp.conf; then
    echo "Everything looks fine already..." 1>&2
    exit 0
fi
if ! apt-get update --fix-missing >/dev/null 2>&1 ; then
   echo 'Failed to update...' 1>&2
   exit 2
fi
   
if ! apt-get install ssmtp mailutils vim -y >/dev/null 2>&1 ; then
    echo 'Failed to install...' 1>&2
    exit 3
fi
if ! cat /home/pi/ssmtp.conf >> /etc/ssmtp/ssmtp.conf ; then
    echo 'Failed to add credentials...' 1>&2
    exit 4
fi
echo 'All setup' 1>&2
exit 0
