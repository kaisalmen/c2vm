# d2vm
Create a Virtual Machines from Docker Images derived from Ubuntu LTS 18.04 & 20.04 (for now).

This work was inspired by: https://github.com/iximiuz/docker-to-linux.git

# Preparation
Build the example image (development machine with docker, nodejs and openjdk)
```
$(cd ubuntu && docker build -t myubuntu .)
```

Create the builder image
```
$(cd builder; docker build -t d2vm .)
```

# Build VM image

This can be build on a linux system or with a priviledged docker container (d2vm build above)
Arguments
 - 1: base image (e.g. myubuntu)
 - 2: disk size MB (e.g. 2048)
```
export LOOPDEV=$(losetup -f); docker run -it --env LOOPDEV=${LOOPDEV} -v /var/run/docker.sock:/var/run/docker.sock -v `pwd`:/workspace:rw --privileged --cap-add SYS_ADMIN --device ${LOOPDEV} d2vm bash buildVM.sh myubuntu 2048
```

## Utilities
Use dive for container inspection:
```
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest
```

## Transform to WSL2 (optional):
```
docker export -o ./staging/myubuntu.tar $(docker run -d myubuntu /bin/true)
wsl --import myubuntu .\myubuntu .\myubuntu.tar --version 2
```
