#!/bin/bash

printf "${WHITE} >> Instalando Docker...\n"
echo
ip_atual=$(curl -s http://checkip.amazonaws.com) >/dev/null 2>&1
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common >/dev/null 2>&1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - >/dev/null 2>&1
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" >/dev/null 2>&1
sudo apt-get update -y >/dev/null 2>&1
sudo apt-get install -y docker-ce >/dev/null 2>&1
sudo usermod -aG docker $(whoami)

docker swarm init --advertise-addr $ip_atual
docker network create -d overlay --attachable proxy