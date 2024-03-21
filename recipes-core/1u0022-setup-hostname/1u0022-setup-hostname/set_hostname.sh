#!/bin/bash

if [ -f /srv/hostname ]; then
    NEW_HOSTNAME=$(cat /srv/hostname)
else
    echo "No hostname file found in /srv/hostname"
    exit 1
fi

hostnamectl set-hostname "$NEW_HOSTNAME"
