#!/bin/bash

ip=$(hostname -I) || true
if [ "$ip" ]; then
    exit 1
fi
if grep --quiet AuthUser /etc/ssmtp/ssmtp.conf; then
    exit 0
fi
apt-get update --fix-missing || exit 2
apt-get install ssmtp mailutils vim -y || exit 3
cat /home/pi/ssmtp.conf | tee -a /etc/ssmtp/ssmtp.conf || exit 4
exit 0

