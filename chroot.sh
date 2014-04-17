#!/usr/bin/bash

#mount --bind /proc root/proc
#mount --bind /sys root/sys
#mount --bind /dev root/dev

PATH=/bin:/sbin:/usr/bin:/usr/sbin:$PATH chroot root bash
