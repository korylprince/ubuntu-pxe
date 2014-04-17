#!/usr/bin/bash

pushd root
rm -Rf vmlinuz*
rm -Rf initrd*
rm -Rf boot/vmlinuz*
rm -Rf boot/initrd*

rm -Rf var/lib/apt/lists/archive*
rm -Rf var/cache/apt/pkgcache.bin
rm -Rf var/cache/apt/srcpkgcache.bin
rm -Rf var/cache/apt/archives/*.deb
rm var/cache/apt/archives/partial/*

popd
