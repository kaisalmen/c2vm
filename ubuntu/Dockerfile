FROM ubuntu:20.04

RUN apt update; apt -y upgrade
RUN apt -y install linux-image-virtual-hwe-20.04
RUN apt -y install systemd-sysv

RUN echo "root:root" | chpasswd
