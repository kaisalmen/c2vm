ARG BASE_IMAGE=ubuntu:20.04
FROM ${BASE_IMAGE}

USER root
RUN apt update; apt -y upgrade
RUN apt install -y linux-image-virtual
RUN DEBIAN_FRONTEND=noninteractive apt install -y systemd-sysv

# network
RUN DEBIAN_FRONTEND=noninteractive apt install -y network-manager net-tools isc-dhcp-client iputils-ping netplan.io ifupdown

# tools
RUN apt install -y nano

# Ensure ethernet is considered managed, otherwise VM is unable to up ethernet interface
COPY ./10-globally-managed-devices.conf /usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf

RUN cd /boot \
    && ln -fs vmlinuz-* vmlinuz \
    && ln -fs initrd.img-* initrd.img

# login
RUN echo "root:root" | chpasswd
