# d2vm
Docker to Virtual Machine

Starting point was: https://github.com/iximiuz/docker-to-linux.git


Build image
```
cd ubuntu; docker build -t myubuntu .; cd ..
```

Use dive for container inspection:
```
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest
```

Create the builder image
```
cd builder; docker build -t d2vm .; cd ..
```

## Build VM image (img and vhdx)

Arguments
 - 1: base image (e.g. myubuntu)
 - 2: loop dev (e.g. ${LOOPDEV})
 - 3: disk size MB (e.g. 2048)
```
LOOPDEV=$(losetup -f)
docker run -it -v `pwd`:/workspace:rw --privileged --cap-add SYS_ADMIN --device ${LOOPDEV} d2vm bash buildVM.sh myubuntu ${LOOPDEV} 2048
```

## Transform to WSL2 (optional):
```
docker export -o ./staging/myubuntu.tar $(docker run -d myubuntu /bin/true)
wsl --import myubuntu D:\Virtuals\WSL2\myubutu .\myubuntu.tar --version 2
```
