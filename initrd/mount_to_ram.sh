#!/bin/sh

echo Creating RAM disk
mount -t ramfs -o size=512M ramfs /root
cd /root
echo Copying to RAM
zcat ../root.img|cpio -i
cd /
