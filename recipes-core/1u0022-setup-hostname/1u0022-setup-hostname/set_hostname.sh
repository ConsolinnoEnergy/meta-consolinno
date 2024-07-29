#! /bin/sh

mount --bind -o ro -n /srv/hostname /etc/hostname
exec hostname "$(cat /srv/hostname)"
