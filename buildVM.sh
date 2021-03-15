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

dd if=/dev/zero of=./staging/linux.img bs=${PARTITION_SIZE_DD} count=1024

function buildPartitionInfo() {
    echo "label: dos" > ./staging/partition.txt
    echo "label-id: 0x5d8b75fc" >> ./staging/partition.txt
    echo "device: new.img" >> ./staging/partition.txt
    echo "unit: sectors" >> ./staging/partition.txt
    echo -e "\nlinux.img1 : start=2048, size=${1}, type=83, bootable" >> ./staging/partition.txt
}
buildPartitionInfo ${PARTITION_SIZE_SFDISK}

sfdisk ./staging/linux.img < ./staging/partition.txt

losetup -D
losetup -o ${LOOP_OFFSET} ${LOOPDEV} ./staging/linux.img
mkfs.ext3 ${LOOPDEV}

if [[ ! -d ./staging/mnt ]]; then
    mkdir -p ./staging/mnt
fi
mount -t auto ${LOOPDEV} ./staging/mnt/

echo -e "\nBuilding images"
cd bootstrap; docker build -t bootstrap . --build-arg BASE_IMAGE=${DOCKER_BASE_IMAGE}; cd ..

echo -e "\nExporting Images..."
docker export -o ./staging/bootstrap.tar $(docker run -d bootstrap /bin/true)

echo -e "\nCopying files..."
tar -xf ./staging/bootstrap.tar -C ./staging/mnt
cp ./bootstrap/10-globally-managed-devices.conf ./staging/mnt/usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf
$(cd ./staging/mnt/boot; ln -fs vmlinuz-* vmlinuz; ln -fs initrd.img-* initrd.img)

echo -e "\nConfiguring extlinux..."
extlinux --install ./staging/mnt/boot/
cp ./builder/syslinux.cfg ./staging/mnt/boot/syslinux.cfg

umount ./staging/mnt
losetup -D

dd if=/usr/lib/syslinux/mbr/mbr.bin of=./staging/linux.img bs=440 count=1 conv=notrunc

echo "Building vhdx..."
qemu-img convert ./staging/linux.img -O vhdx -o subformat=dynamic ./staging/linux.vhdx
