#! /bin/sh

if [ -f /srv/hostname ]; then
    NEW_HOSTNAME=$(cat /srv/hostname)
else
    echo "No hostname file found in /srv/hostname"
    exit 1
fi

echo $NEW_HOSTNAME > /tmp/hostname
mount --bind /tmp/hostname /etc/hostname
