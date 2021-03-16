# Container to Virtual Machine (c2vm)

Create virtual machines from containers derived from Ubuntu LTS (18.04 or 20.04).
Other OS may be supported later. This is a proof-of-concept: Create bootable VMs from existing container images. Docker is used for image building and execution. The process could be adapted to buildah and podman

The build script `buildVM.sh` performs all operations within a builder container.
It creates a bootable partition in a loop back device.
Then it extends the provided image with a bootstrap image that install a kernel, systemd and some utils.
The previously created partition is mounted and then the bootstrap image is exported there. extlinux is installed and an MBR is written. Additionally to the img a vhdx is created.

This work was inspired by: https://github.com/iximiuz/docker-to-linux.git 

## Required software
docker installed on a Linux platform (WSL2 works) if you use the builder container.  If you want to run the build script directly you need to have `extlinux` and `qemu-utils` installed.

## Preparation
Create the builder image (`c2vm/builder`):
```
$(cd builder && docker build -t c2vm/builder .)
```

Optional: Build the example images:
- `c2vm/basic`: Ubuntu 20.04 updated + git
- `c2vm/devbox`: Extends example and installs many development tools from (https://github.com/kaisalmen/wsltooling)
- `c2vm/devboxui`: Extends devbox and installs xfce4 and firefox
```
$(cd examples/basic; docker build -t c2vm/basic .)
$(cd examples/devbox; docker build -t c2vm/devbox .)
$(cd examples/devboxui; docker build -t c2vm/devboxui .)
```

## Build VM image

Best use `buildVM.sh` from within `c2vm/builder` that was built before.
Execute the script as specified below and change the two arguments as required:
 - 1: image to be converted and extended with bootstrap (e.g. `c2vm/basic`)
 - 2: disk size MB (e.g. 2048, but for the larger images, you must create bigger initial partitions)
```
export LOOPDEV=$(losetup -f); docker run -it --env LOOPDEV=${LOOPDEV} -v /var/run/docker.sock:/var/run/docker.sock -v `pwd`:/workspace:rw --privileged --device ${LOOPDEV} c2vm/builder bash buildVM.sh c2vm/basic 2048
```
Create a new VM with qemu/kvm or with Hyper-V (1st gen VM) and use the virtuals disks `linux.img` or `linux.vhdx`.

## Extras

### Transform container to WSL2:
Export the container:
```
docker export -o ./staging/devbox.tar $(docker run -d c2vm/devbox /bin/true)
```
Copy to location where you can access the tarball with Powershell and import a new WSL
```
wsl --import devbox .\devbox devbox.tar --version 2
```

## Utilities
Use dive for container inspection:
```
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest
```
