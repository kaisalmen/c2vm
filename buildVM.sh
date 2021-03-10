#!/bin/sh
set -xe

#PARTITION_SIZE=8192
PARTITION_SIZE=$(expr 1024 \* 1024 \* 1024)
LOOP_OFFSET=$(expr 512 \* 2048)
LINUX_TAR=${1}
LOOPDEV=${2}

dd if=/dev/zero of=./linux.img bs=${PARTITION_SIZE} count=1
#dd if=/dev/zero bs=1MiB of=./linux.img conv=notrunc oflag=append count=1025
sfdisk ./linux.img < ./builder/partition.txt

losetup -D
losetup -o ${LOOP_OFFSET} ${LOOPDEV} ./linux.img
mkfs.ext3 ${LOOPDEV}

if [[ ! -d ./staging/mnt ]]; then
    mkdir -p ./staging/mnt
fi
mount -t auto ${LOOPDEV} ./staging/mnt/
#mount -o loop,rw,sync,offset=${LOOP_OFFSET} -t auto ./linux.img ./staging/mnt

echo -e "\nCopying files"
if [[ ! -d ./staging/linux ]]; then
    mkdir -p ./staging/linux
fi
tar -xf ${LINUX_TAR} -C ./staging/linux
cp -R ./staging/linux/. ./staging/mnt/

echo -e "\nextlinux"
extlinux --install ./staging/mnt/boot/
cp ./builder/syslinux.cfg ./staging/mnt/boot/syslinux.cfg

umount ./staging/mnt
losetup -D

dd if=/usr/lib/syslinux/mbr/mbr.bin of=./linux.img bs=440 count=1 conv=notrunc
