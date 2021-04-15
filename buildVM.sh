#!/bin/bash

set -euo pipefail

if [[ -z ${LOOPDEV} ]]; then
    echo "LOOPDEV environment variable has not been set. Please check README.md"
fi

if [[ ! $# -eq 2 ]]; then
    echo "Please provide three arguments:"
    echo -e "\n1. The base image"
    echo -e "\n2. The size of the virtual disk in MB (default 2048)"
    exit 1;
fi

DOCKER_BASE_IMAGE=${1}
PARTITION_MB=${2-2048}
PARTITION_SIZE_DD=$(expr ${PARTITION_MB} \* 1024)
PARTITION_SIZE_SFDISK=$(expr 2 \* ${PARTITION_SIZE_DD})
LOOP_OFFSET=$(expr 512 \* 2048)

echo -e "\nStarting with the following configuration:"
echo -e "Base Image: ${DOCKER_BASE_IMAGE}"
echo -e "Disk Size: ${PARTITION_MB}"
echo -e "Loop Device partition offset: ${LOOP_OFFSET}"


echo -e "\nBuilding bootstrap image:"
cd bootstrap; docker build -t c2vm/bootstrap . --build-arg BASE_IMAGE=${DOCKER_BASE_IMAGE}; cd ..

echo -e "\nExporting bootstrap image:"
docker export -o ./staging/bootstrap.tar $(docker run -d c2vm/bootstrap /bin/true)


echo -e "\nCreating partition in image file:"
function buildPartitionInfo() {
    echo "label: dos" > ./staging/partition_info.txt
    echo "label-id: 0x6332766d" >> ./staging/partition_info.txt
    echo "device: linux.img" >> ./staging/partition_info.txt
    echo "unit: sectors" >> ./staging/partition_info.txt
    echo -e "\nlinux.img1 : start=2048, size=${1}, type=83, bootable" >> ./staging/partition_info.txt
}
buildPartitionInfo ${PARTITION_SIZE_SFDISK}

dd if=/dev/zero of=./staging/linux.img bs=${PARTITION_SIZE_DD} count=1024
sfdisk ./staging/linux.img < ./staging/partition_info.txt


echo -e "\nCreating filesystem in loopback device:"
losetup -D
losetup -o ${LOOP_OFFSET} ${LOOPDEV} ./staging/linux.img
mkfs.ext4 ${LOOPDEV}

if [[ ! -d ./staging/mnt ]]; then
    mkdir -p ./staging/mnt
fi
mount -t auto ${LOOPDEV} ./staging/mnt/


echo -e "\nCopying files to mounted loop disk root:"
tar -xf ./staging/bootstrap.tar -C ./staging/mnt

echo -e "\nConfiguring extlinux:"
extlinux --install ./staging/mnt/boot/ 
cp ./builder/syslinux.cfg ./staging/mnt/boot/syslinux.cfg

umount ./staging/mnt
losetup -D


echo -e "\nCreating master boot record:"
dd if=/usr/lib/syslinux/mbr/mbr.bin of=./staging/linux.img bs=440 count=1 conv=notrunc
