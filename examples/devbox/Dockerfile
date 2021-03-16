FROM c2vm/basic

RUN DEBIAN_FRONTEND=noninteractive apt install -y tzdata curl make unzip

# create user
ARG username=vmuser
ARG password=vmuser
RUN adduser ${username} && usermod -aG sudo ${username} \
    && echo "${username}:${password}" | chpasswd

# ensure that user can peform all install steps
RUN echo "${username} ALL=(root) NOPASSWD:ALL" > /tmp/${username}_all \
    && visudo -c -f /tmp/${username}_all \
    && cp /tmp/${username}_all /etc/sudoers.d/${username}_all

USER ${username}
WORKDIR /home/${username}

# Use the scripts from wsltooling repo to install various compilers and development tool chains
RUN git clone https://github.com/kaisalmen/wsltooling && mkdir -p /home/${username}/Downloads
RUN bash ./wsltooling/scripts/install/installDocker.sh
RUN bash ./wsltooling/scripts/install/installNodejs.sh
RUN bash ./wsltooling/scripts/install/installDeno.sh
RUN bash ./wsltooling/scripts/install/installRust.sh
RUN bash ./wsltooling/scripts/install/installOpenjdk.sh
RUN bash ./wsltooling/scripts/install/installMaven.sh

# remove sudo priviledges
USER root
RUN rm /etc/sudoers.d/${username}_all
USER ${username}
WORKDIR /home/${username}
