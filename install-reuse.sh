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

function dynamic_ip()
{
    GW=$1
    MASK=$2
    CFG="$3/etc/network/interfaces"
    sudo cp -v $CFG "$CFG.bak"
    echo "netmask $MASK" | sudo tee -a $CFG
    echo "gateway $GW" | sudo tee -a $CFG
}

#http://sizious.com/2015/08/28/setting-a-static-ip-on-raspberry-pi-on-raspbian-20150505/
function static_ip()
{
    IP=$1
    ROUTER=$2
    DHCP="$3/etc/dhcpcd.conf"
    sudo cp -v $DHCP "$DHCP.orig"
    echo 'interface wlan0' | sudo tee -a $DHCP
    echo "  static ip_address=$IP/24" | sudo tee -a $DHCP
    echo "  static routers=$ROUTER" | sudo tee -a $DHCP
    echo "  static domain_name_servers=8.8.8.8" | sudo tee -a $DHCP
}

function generic_setup()
{
    rm -fr $1/home/pi/.ssh
    mkdir $1/home/pi/.ssh
    cat ~/.ssh/id_rsa.pub >> $1/home/pi/.ssh/authorized_keys

    sudo cp -v $1/usr/share/zoneinfo/America/New_York $1/etc/localtime

    RPI="$1/home/pi/git/rpi"
    rm -fr $RPI
    mkdir -p $RPI
    git clone https://github.com/petrum/rpi.git $RPI
    
    sudo cp -v $1/etc/wpa_supplicant/wpa_supplicant.conf $1/etc/wpa_supplicant/wpa_supplicant.conf.bak
    sudo cp -v ~/rpi-private/wpa_supplicant.conf $1/etc/wpa_supplicant
}

function sethostname()
{
    BUILD=~/.rpi-counter.txt
    if [ ! -f $BUILD ]; then
        echo 0 > $BUILD
    fi
    COUNTER=$(cat $BUILD)
    #NAME=$(date +"$1-%Y%m%d-%H%M%S")
    NAME="$1-$COUNTER"
    sudo sed -i "s/raspberrypi/$NAME/g" $2/etc/hosts
    sudo sed -i "s/raspberrypi/$NAME/g" $2/etc/hostname
    ((COUNTER++))
    echo $COUNTER > $BUILD
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


