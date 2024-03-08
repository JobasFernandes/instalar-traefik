#!/bin/bash
GREEN='\033[1;32m'
BLUE='\033[1;34m'
WHITE='\033[1;37m'
RED='\033[1;31m'
YELLOW="\033[1;33m"

ARCH=$(uname -m)
ip_atual=$(curl -s http://checkip.amazonaws.com)

if [ "$ARCH" == "x86_64" ]; then
    printf " >> ${GREEN}Instalando Docker para arquitetura x86_64...${WHITE} \n"
    sleep 3
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update -y
    sudo apt-get install -y docker-ce
    sudo usermod -aG docker $(whoami)
    docker swarm init --advertise-addr $ip_atual
    docker network create -d overlay --attachable proxy
elif [ "$ARCH" == "aarch64" ]; then
    printf " >> ${GREEN}Instalando Docker para arquitetura aarch64...${WHITE} \n"
    sleep 3
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update -y
    sudo apt-get install -y docker-ce
    sudo usermod -aG docker $(whoami)
    docker swarm init --advertise-addr $ip_atual
    docker network create -d overlay --attachable proxy
else
    printf "${RED}Arquitetura não suportada: $ARCH\n"
    exit 1
fi
