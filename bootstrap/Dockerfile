ARG BASE_IMAGE=ubuntu:20.04
FROM ${BASE_IMAGE}

RUN apt update; apt -y upgrade
RUN apt install -y linux-image-virtual-hwe-20.04
RUN DEBIAN_FRONTEND=noninteractive apt install -y systemd-sysv

# network
RUN DEBIAN_FRONTEND=noninteractive apt install -y network-manager net-tools isc-dhcp-client iputils-ping netplan.io ifupdown

# tools
#RUN DEBIAN_FRONTEND=noninteractive apt install -y xfce4
RUN apt install -y nano

# login
RUN echo "root:root" | chpasswd
