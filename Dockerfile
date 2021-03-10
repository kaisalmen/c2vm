FROM ubuntu:18.04

RUN apt update; apt -y upgrade
RUN apt -y install linux-image-virtual
RUN apt -y install systemd-sysv

RUN echo "root:root" | chpasswd
