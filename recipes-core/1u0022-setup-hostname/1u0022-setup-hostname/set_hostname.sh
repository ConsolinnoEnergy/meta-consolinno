#! /bin/sh

if [ -f /srv/hostname ]; then
    mount --bind /srv/hostname /etc/hostname
else
    echo "No hostname file found in /srv/hostname"
    exit 1
fi
