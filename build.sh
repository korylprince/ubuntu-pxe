#!/usr/bin/bash

./umount.sh

pushd /opt/ubuntu_core/root
find . | cpio -o -H newc | gzip > /opt/ubuntu_core/root.img
popd

mv root.img initrd/

pushd /opt/ubuntu_core/initrd
find . | cpio -o -H newc | gzip > /opt/ubuntu_core/initrd.img
popd

if [ -f deploy.sh ]
then
    ./deploy.sh
fi
