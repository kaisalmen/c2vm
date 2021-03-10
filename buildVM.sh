#!/bin/sh

LOOPDEV=$(losetup -f);
echo "Using: ${LOOPDEV}"
dd if=/dev/zero of=/os/linux.img bs=$(expr 2048 \* 1024 \* 1024) count=1
sfdisk ./os/linux.img < /os/builder/partition.txt
losetup -o $(expr 512 \* 2048) ${LOOPDEV} ./os/linux.img
mkfs.ext3 ${LOOPDEV}
mkdir /os/mnt
mount -t auto ${LOOPDEV} /os/mnt/
tar -xf /os/${1} -C /os/mnt/

extlinux --install /os/mnt/boot/
cp /os/builder/syslinux.cfg /os/mnt/boot/syslinux.cfg

echo "Boot dir (/boot):"
ls -lha /os/mnt/boot

umount /os/mnt
losetup -D

dd if=/usr/lib/syslinux/mbr/mbr.bin of=/os/linux.img bs=440 count=1 conv=notrunc
