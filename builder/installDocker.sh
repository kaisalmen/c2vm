#!/bin/bash

set -euo pipefail
DIR_ME=$(realpath $(dirname $0))

apt update
apt remove docker docker.io containerd runc
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y --no-install-recommends docker-ce

VERSION_DOCKER_COMPOSE="1.29.1"
curl -fSL "https://github.com/docker/compose/releases/download/${VERSION_DOCKER_COMPOSE}/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
