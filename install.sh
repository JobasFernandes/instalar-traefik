#!/bin/bash
GREEN='\033[1;32m'
WHITE='\033[1;37m'

printf " >> ${GREEN}Atualizando a VPS...${WHITE} \n"
sleep 3
UBUNTU_VERSION=$(lsb_release -sr)
if [ "$UBUNTU_VERSION" == "22.04" ]; then
    echo " > Versao do Ubuntu é $UBUNTU_VERSION. Proseguindo com a atualização..."
    echo
    sleep 2

    if grep -q "NEEDRESTART_MODE" /etc/needrestart/needrestart.conf; then
        sudo sed -i 's/^NEEDRESTART_MODE=.*/NEEDRESTART_MODE=a/' /etc/needrestart/needrestart.conf
    else
        echo 'NEEDRESTART_MODE=a' | sudo tee -a /etc/needrestart/needrestart.conf
    fi
    echo
    sleep 2
else
    echo " > Versao do Ubuntu é $UBUNTU_VERSION. Proseguindo com a atualização..."
    echo
    sleep 2
fi
sudo apt-mark hold linux-firmware >/dev/null 2>&1
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y >/dev/null 2>&1
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" >/dev/null 2>&1
sudo DEBIAN_FRONTEND=noninteractive apt-get install build-essential -y >/dev/null 2>&1
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y apparmor-utils >/dev/null 2>&1
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y zip >/dev/null 2>&1

printf " >> ${GREEN}Configurando timezone...${WHITE} \n"
sleep 3
timedatectl set-timezone America/Sao_Paulo

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
