# d2vm
Docker to Virtual Machine

Destilled from https://serverfault.com/questions/682322/create-a-vhd-file-from-a-linux-disk
and
https://github.com/iximiuz/docker-to-linux.git


Build image
```
docker build -t myubuntu .
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

Use a builder image
```
cd builder; docker build -t d2vm .
docker run -it -v `pwd`:/os:rw --cap-add SYS_ADMIN --device $(losetup -f) d2vm bash buildVM.sh myubuntu.tar
```

```
qemu-img convert linux.img -O vhdx -o subformat=dynamic linux.vhdx
```
