#!/bin/bash
. "$(dirname $0)/../install-reuse.sh"
READER=$(selectMicroSD)
#diskcopy /home/petrum/Downloads/2016-03-18-raspbian-jessie.img $READER
diskcopy /home/petrum/Downloads/2016-03-18-raspbian-jessie-lite.img $READER
expandFS $READER
DEST=$(mountFS $READER 2)
sethostname motion $DEST
get_rpi $DEST
sudo sed -i 's|^exit 0|/home/pi/git/rpi/motion/motion.py >> /root/motion.log 2>\&1\nexit 0|g' $DEST/etc/rc.local
#sudo mkdir -p $DEST/root/.ssh
#sudo cp -v /home/petrum/rpi-private/id_rsa $DEST/root/.ssh
#sudo chmod 600 $DEST/root/.ssh/id_rsa
#sudo ls -ltr $DEST/root/.ssh/id_rsa

sudo cp -v /home/petrum/rpi-private/ssmtp.conf $DEST/home/pi/ssmtp.conf
cat << EOF > $DEST/home/pi/setup.sh
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
EOF
chmod a+x $DEST/home/pi/setup.sh
umountFS $DEST
