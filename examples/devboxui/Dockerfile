ARG username=vmuser
FROM c2vm/devbox

USER root
RUN DEBIAN_FRONTEND=noninteractive apt install -y xfce4 firefox virt-manager dbus-x11 x11-apps

USER ${username}
RUN bash ./wsltooling/scripts/install/installChrome.sh
