# How to create Ubuntu Core PXE Image

## Introduction

It's not as easy as it should be to get a simple linux PXE image booting. [Ubuntu Core](https://wiki.ubuntu.com/Core) is a step in the right direction, but we need to do a little work first.

## How it works

The standard ubuntu initrd.img starts it's `init` process, does some init-y things, and hopes by the time it get's to the end of it's processes that something has mounted to /root so it can boot fully to that. Generally grub or something similar will pass boot options that tell it to mount a particular disk.

Unfortunately, there's no option to tell `init` to grab a rootfs from tftp, so we have to get a little crazy. The busybox included in the initrd doesn't have tftp built in, and even if did, busybox tftp is much slower compared to [PXELINUX](http://www.syslinux.org/wiki/index.php/PXELINUX). It's easier just to build the root.img straight into the initrd.img and copy it over to a RAM disk as part of `init`. 

In the end you end up with an initrd.img that weighs about 100MB. The majority of that lives in `/lib/modules`, so if you know what you need, you can slim down the image a lot.

## Building the Image

These aren't copy and paste commands. Instead it's more of an outline to put everything together.


    # get resources
    mkdir /opt/ubuntu_core
    cd /opt/ubuntu_core
    mkdir root
    wget <core.tgz>
    wget <kernel.deb>
    cp <chroot.sh> ./
    cp <umount.sh> ./
    cp <clean.sh> ./
    cp <build.sh> ./

    #create optional deploy.sh to be run after building with build.sh
    vim deploy.sh
    chmod +x deploy.sh

    # extract filesystem
    tar xzvfp <core.tgz> -C root

    # add dns settings
    vim root/etc/resolv.conf

    # put kernel in filesystem
    cp <kernel.deb> root/

    # chroot
    # if you encounter errors you may need to mount /proc /sys and /dev into root
    # see chroot.sh code
    ./chroot.sh

    # install kernel
    dpkg -i <kernel.deb>

    # back out of chroot
    exit

    # get kernel and initrd
    cp root/boot/<vmlinuz> vmlinuz
    cp root/boot/<initrd.img> initrd.img

    # extract initrd
    cd initrd
    zcat ../initrd.img|cpio -i

    # make zcat easily available
    cd bin
    ln -s busybox zcat

    # go back to initrd directory
    cd ..

    # get mount to ram script
    cp <mount_to_ram.sh> ./

    # add "/mount_to_ram.sh" on line before "# Export relevant variables"
    vim init

    # go back to main directory
    cd ..

    # do anything else you want to do.. install packages etc
    ./chroot.sh

    # clean up unneeded files
    ./clean.sh

    # build initrd with root.img included
    ./build.sh

## PXE booting

This assumes you already know how PXELINUX works. Just use these two lines in your menu entry:

    kernel /path/to/vmlinuz
    initrd /path/to/initrd.img

## Networking

From my research, adding the following line to your menu entry should make you client get DHCP on boot:

    append ip=dhcp

In actuality, that only works sometimes. It's not too hard to get it working all the time.

    # get to working directory
    cd /opt/ubuntu_core

    #chroot
    ./chroot.sh

    # install dhcp client
    apt-get update
    apt-get install isc-dhcp-client

    # Tell the networking system to give you DHCP
    # Put the following two lines in /etc/network/interfaces
    # auto eth0
    # iface eth0 inet dhcp
    vim root/etc/network/interfaces

    # get out of chroot
    exit

    # clean up unneeded files
    ./clean.sh

    # build initrd with root.img included
    ./build.sh


## Troubleshooting

* Don't run `apt-get upgrade` or risk killing your rootfs with packages not meant to be installed in Ubuntu Core.
* Having trouble installing packages with `apt-get` giving you weird messages? Make sure `/dev`, `/sys`, and `/proc` are mounted. Look at the comments in `chroot.sh` for help.
* `mount_to_ram.sh` creates a RAM disk of `512MB` to copy the rootfs into. If you need more or less just edit that script and rebuild.

## Copyright

All this is straight-up Public Domain.
