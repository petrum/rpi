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
    local TMP=~/tmp/$$-$2
    mkdir -p "$TMP"
    PART="/dev/${1}$2"
    echo "Mounting '$PART' into '$TMP'" 1>&2
    sudo mount "/dev/${1}$2" "$TMP"
    echo $TMP
}

function umountFS()
{
    sudo umount "$1"
    rm -r "$1"
    echo "Unmounted and removed '$1'" 1>&2
    sync
}

function networkSetup()
{
    sudo cp -v $2/usr/share/zoneinfo/America/New_York $2/etc/localtime
    sudo cp -v $1/interfaces $2/etc/network
    sudo cp -v ~/wpa_supplicant.conf $2/etc/wpa_supplicant

    rm -fr $2/home/pi/.ssh
    mkdir $2/home/pi/.ssh
    cat ~/.ssh/id_rsa.pub >> $2/home/pi/.ssh/authorized_keys
}

function get_rpi()
{
    RPI="$1/home/pi/git/rpi"
    rm -fr $RPI
    mkdir -p $RPI
    git clone https://github.com/petrum/rpi.git $RPI
}

function sethostname()
{
    NAME=$(date +"$1-%Y%m%d-%H%M%S")
    sudo sed -i "s/raspberrypi/$NAME/g" $2/etc/hosts
    sudo sed -i "s/raspberrypi/$NAME/g" $2/etc/hostname
}

function static_ip()
{
    IP=$1
    DHCP="$2/etc/dhcpcd.conf"
    sudo cp -v $DHCP "$DHCP.orig"
    echo 'interface wlan0' | sudo tee -a $DHCP
    echo "static ip_address=$IP/24" | sudo tee -a $DHCP
}

function enable_spi()
{
    sudo sed -i 's|#dtparam=spi=on|dtparam=spi=on|g' $1/config.txt
}

function get_MAX7219array()
{
    rm -fr $1/home/pi/MAX7219array
    git clone https://github.com/JonA1961/MAX7219array.git $1/home/pi/MAX7219array
    sed -i 's/NUM_MATRICES = 8/NUM_MATRICES = 7/g' $1/home/pi/MAX7219array/MAX7219array.py
    cat << EOF >> $1/home/pi/setup.sh
sudo apt-get install build-essential python-dev python-pip
sudo pip install spidev
EOF
    chmod a+x $1/home/pi/setup.sh
}

function autostart_MAX7219array_demo()
{
    chmod a+x $1/home/pi/MAX7219array/MAX7219array_demo.py    
    sudo sed -i 's|^exit 0|cd /home/pi/MAX7219array; ./MAX7219array_demo.py\nexit 0|g' $1/etc/rc.local
}


