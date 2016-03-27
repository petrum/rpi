#!/bin/bash

ip=$(hostname -I) || true
if [ ! "$ip" ]; then
    echo "No IP..."
    exit 1
fi
echo "IP = $ip"
if [[ -f /root/setup.done ]] ; then
    echo "Everything looks fine already..."
    exit 0
fi

if ! apt-get update --fix-missing >/dev/null 2>&1 ; then
   echo 'Failed to update...'
   exit 2
fi
   
#if ! apt-get install python-pip python-dev vim -y >/dev/null 2>&1 ; then
#    echo 'Failed to install...'
#    exit 3
#fi

#if ! pip install spidev >/dev/null 2>&1 ; then
#    echo 'Failed to install spidev...'
#    exit 3
#fi

touch /root/setup.done
echo 'All setup'
exit 0

