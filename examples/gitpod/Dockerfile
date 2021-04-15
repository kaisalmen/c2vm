FROM gitpod/workspace-full
ARG username=gitpod
ARG hostname=gpvm

USER root
RUN apt update && apt upgrade -y
# install gnome desktop env
RUN DEBIAN_FRONTEND=noninteractive apt install -y ubuntu-gnome-desktop

# ensure theia can be build
RUN apt install -y firefox dbus-x11 x11-apps openssh-server libx11-dev libxkbfile-dev
RUN echo "${username}:${username}" | chpasswd

# make env vars available in systemd context. Fix nginx pid
COPY systemd/DefaultEnvironment /home/${username}/DefaultEnvironment
COPY apache2/envvars /home/${username}/envvars

RUN cat /home/${username}/DefaultEnvironment >> /etc/systemd/system.conf \
    && sed -i "/pid.*/c\pid /run/nginx.pid;" /etc/nginx/nginx.conf \
    && cp /home/${username}/envvars /etc/apache2/envvars
    && hostnamectl set-hostname ${hostname}
    && rm /home/${username}/DefaultEnvironment \
    && rm /home/${username}/envvars

USER ${username}
WORKDIR /home/${username}
SHELL ["/bin/bash", "-c"]

RUN git clone https://github.com/kaisalmen/wsltooling \
    && git clone https://github.com/eclipse-theia/theia \
    && mkdir -p Downloads \
    && mkdir workspace \
    && bash ./wsltooling/scripts/install/installChrome.sh

RUN rm -fr .nvm \
    && rm -fr /home/${username}/.bashrc.d/50-node \
    && bash wsltooling/scripts/install/installNodejs.sh \
    && source .local/bin/env/configureN.sh \
    && n 12 \
    && npm install -g yarn

ENV THEIA=/home/${username}/theia
RUN source .local/bin/env/configureN.sh \
    && echo ${THEIA} \
    && yarn --cwd ${THEIA}

RUN source .bashrc \
    && yarn --cwd ${THEIA}/examples/browser
