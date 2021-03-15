FROM ubuntu:20.04

RUN apt update && apt upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt install -y tzdata git sudo curl make unzip

# create user
ARG username=vmuser
ARG password=vmuser
#RUN adduser ${username}
#RUN usermod -aG sudo ${username}
#RUN export PS1=''
#USER ${username}

# and install all as user
RUN cd /root && git clone https://github.com/kaisalmen/wsltooling
RUN cd /root && bash ./wsltooling/scripts/config/system/createUser.sh $username
RUN mv /root/wsltooling /home/${username}/wsltooling \
    && chown -R ${username}:${username} /home/${username}/wsltooling

USER ${username}
WORKDIR /home/${username}

ENV USERNAME=${username}
#RUN echo ${password} | sudo -S bash ./wsltooling/scripts/install/installNodejs.sh
RUN bash ./wsltooling/scripts/install/installNodejs.sh
RUN bash ./wsltooling/scripts/install/installDocker.sh
RUN bash ./wsltooling/scripts/install/installOpenjdk.sh

USER root
RUN echo "${username}:${password}" | chpasswd

USER ${username}