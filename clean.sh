#!/usr/bin/bash

pushd root
rm vmlinuz*
rm initrd*
rm boot/vmlinuz*
rm boot/initrd*
rm linux-image*


rm var/lib/apt/lists/archive*
rm var/cache/apt/pkgcache.bin
rm var/cache/apt/srcpkgcache.bin
rm var/cache/apt/archives/*.deb
rm var/cache/apt/archives/partial/*

popd
