ARG BASE_IMAGE=ubuntu:20.04
FROM ${BASE_IMAGE}

RUN apt update; apt -y upgrade
# tzdate requires user interaction, therefore noninteractive is required
RUN INTERACTION=noninteractive apt install -y extlinux tzdata net-tools qemu-utils

COPY ./installDocker.sh /home/installDocker.sh
RUN bash -x /home/installDocker.sh
RUN mkdir /workspace

WORKDIR /workspace
