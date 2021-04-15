ARG username=vmuser
ARG BASE_IMAGE=docker.pkg.github.com/kaisalmen/c2vm/examples-devbox
FROM ${BASE_IMAGE}

USER root
RUN DEBIAN_FRONTEND=noninteractive apt install -y xfce4 firefox virt-manager dbus-x11 x11-apps

USER ${username}
RUN bash ./wsltooling/scripts/install/installChrome.sh
