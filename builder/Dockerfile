FROM ubuntu:20.04

RUN apt update; apt -y upgrade
RUN apt install -y extlinux
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata net-tools

COPY ./installDocker.sh /home/installDocker.sh
RUN bash -x /home/installDocker.sh
RUN mkdir /workspace

RUN apt install -y qemu-utils

WORKDIR /workspace
