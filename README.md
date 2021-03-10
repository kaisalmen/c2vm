# d2vm
Docker to Virtual Machine

Destilled from https://serverfault.com/questions/682322/create-a-vhd-file-from-a-linux-disk
and
https://github.com/iximiuz/docker-to-linux.git


Build image
```
cd ubuntu; docker build -t myubuntu .; cd ..
```

Use dive for container inspection:
```
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest
```

Export image
```
docker export -o myubuntu.tar $(docker run -d myubuntu /bin/true)
```

Transform to WSL2 (optional):
```
wsl --import myubuntu D:\Virtuals\WSL2\myubutu .\myubuntu.tar --version 2
```

Create the builder image
```
cd builder; docker build -t d2vm .; cd ..
```

Use a builder image
```
LOOPDEV=$(losetup -f)
docker run -it -v `pwd`:/workspace:rw --privileged --cap-add SYS_ADMIN --device ${LOOPDEV} d2vm bash buildVM.sh myubuntu.tar ${LOOPDEV}
```

```
qemu-img convert linux.img -O vhdx -o subformat=dynamic linux.vhdx
```
