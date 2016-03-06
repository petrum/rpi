#!/bin/bash

trap "exit 1" TERM

function abort
{
    kill -s TERM $$
    exit 0
}

function selectMicroSD()
{
    lsblk 1>&2
    local USB_READER=$(lsblk -Sm | grep -i card | grep usb | cut -f1 -d' ')
    if [[ "$USB_READER" == '' ]]; then
        echo "No USB reader found! Exiting..." 1>&2
        abort
    fi

    echo "Using '$USB_READER'... Please confirm: [y/N]" 1>&2
    read ANSWER
    echo "The answer is '$ANSWER'" 1>&2

    if [[ "$ANSWER" != "y" ]]; then
        echo "Exiting now..." 1>&2
        abort
    fi

    if grep -qs "/dev/${USB_READER}1" /proc/mounts; then
        sudo umount "/dev/${USB_READER}1"
    fi

    if grep -qs "/dev/${USB_READER}2" /proc/mounts; then
        sudo umount "/dev/${USB_READER}2"
    fi
    echo $USB_READER
}

function diskcopy()
{
    date
    local BEGIN=$(date +%s)
    echo "dd $1 $2"
    sudo dcfldd bs=4M if="$1" of="/dev/$2"
    local END=$(date +%s)
    local ELAPSED=$((END - BEGIN))
    local MIN=$((ELAPSED / 60))
    local SEC=$((ELAPSED % 60))
    echo "Elapsed $MIN min $SEC sec"
}

function expandFS()
{
    echo "d
2
n
p
2
131072

w" | sudo fdisk /dev/$1
    sudo e2fsck -f /dev/${1}2
    sudo resize2fs /dev/${1}2
}

function mountFS()
{
    local DEST=~/tmp/$$
    mkdir -p $DEST
    #echo $DEST 1>&2
    sudo mount "/dev/${1}2" "$DEST"
    echo $DEST
}

function umountFS()
{
    sudo umount "$DEST"
    rm -r "$DEST"
    sync
}

function pigpioInstall()
{
    rm -fr $1
    git clone https://github.com/joan2937/pigpio $1
    cat << EOF >> $2
cd pigpio
make
sudo make install
EOF
}

function networkSetup()
{
    sudo cp -v $2/usr/share/zoneinfo/America/New_York $2/etc/localtime
    sudo cp -v $1/interfaces $2/etc/network
    sudo cp -v $1/rc.local $2/etc
    sudo cp -v $1/wpa_supplicant.conf $2/etc/wpa_supplicant
    ls -l $2/etc/network/interfaces $2/etc/rc.local $2/etc/wpa_supplicant/wpa_supplicant.conf
    rm -fr $2/home/pi/.ssh
    mkdir $2/home/pi/.ssh
    cat ~/.ssh/id_rsa.pub >> $2/home/pi/.ssh/authorized_keys
}

function aptget()
{
    cat << EOF > $1/home/pi/setup.sh
sudo apt-get install tmux vim -y
EOF
    chmod a+x $1/home/pi/setup.sh
}

function get-rpi()
{
    mkdir -p $2/home/pi/git/rpi
    rsync --recursive $1 $2/home/pi/git/rpi  
}

function sethostname()
{
    sudo sed -i "s/raspberrypi/$1/g" $2/etc/hosts
    sudo sed -i "s/raspberrypi/$1/g" $2/etc/hostname
}
