# TRAEFIK EM MODO SWARM

### PRÉ-REQUISITOS

1. VPS Ubuntu 20.04 +
2. Instale o Docker e o Docker Compose e inicie o Swarm
```shell
bash <(wget -qO- https://raw.githubusercontent.com/JobasFernandes/instalar-traefik-swarm/main/install.sh)
```
3. Instalar o Apache2-Utils _(Comando abaixo)_
```shell
sudo apt install apache2-utils -y
```
</BR>

### INSTALAÇÃO DO TRAEFIK

- Altere as variaveis abaixo dentro do traefik.yaml com seus dados</BR>

Obs.: Para acessar o dashboard do traefik precisará apontar um subdominio para o `$IP_DA_VPS`</BR>
ex: _traefik.seudominio.com.br_

1. `${TRAEFIK_EMAIL}`
2. `${TRAEFIK_URL}`
3. `${TRAEFIK_CREDS}`
- As credenciais do traefik podem ser geradas com o comando abaixo substituindo `$TRAEFIK_EMAIL` e `$TRAEFIK_PASS`
```shell
htpasswd -nb $TRAEFIK_EMAIL $TRAEFIK_PASS
```
- Por fim execute a stack e aguarde o traefik subir
```shell
docker stack deploy --prune --resolve-image always -c traefik.yaml traefik
```
