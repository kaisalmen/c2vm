#!/bin/sh
set -xe

PARTITION_SIZE=$(expr 2048 \* 1024 \* 1024)
LOOP_OFFSET=$(expr 512 \* 2048)
LINUX_TAR=${1}
LOOPDEV=${2}

dd if=/dev/zero of=./linux.img bs=${PARTITION_SIZE} count=1
sfdisk ./linux.img < ./builder/partition.txt
losetup -o ${LOOP_OFFSET} ${LOOPDEV} ./linux.img
mkfs.ext3 ${LOOPDEV}

if [[ ! -d ./mnt ]]; then
    mkdir ./mnt
fi
mount -t auto ${LOOPDEV} ./mnt/
#sudo mount -o loop,rw,sync,offset=${LOOP_OFFSET} -t auto ./linux.img ./mnt

tar -xf ${LINUX_TAR} -C ./mnt
extlinux --install ./mnt/boot/
cp ./builder/syslinux.cfg ./mnt/boot/syslinux.cfg

echo "Boot dir (/boot):"
ls -lha ./mnt/boot

losetup -D
umount ./mnt

dd if=/usr/lib/syslinux/mbr/mbr.bin of=./linux.img bs=440 count=1 conv=notrunc
