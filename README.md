# TRAEFIK EM MODO SWARM

### PRÉ-REQUISITOS

1. VPS Ubuntu **20.04** +
2. Instale o **Docker** e o **Docker Compose**
```shell
bash <(wget -qO- https://raw.githubusercontent.com/JobasFernandes/instalar-traefik-swarm/main/install.sh)
```
3. Instalar o **Apache2-Utils** _(Comando abaixo)_
```shell
sudo apt install apache2-utils -y
```
</BR>

### INSTALAÇÃO DO TRAEFIK

- Crie uma pasta para o **traefik**
```shell
mkdir -p $(pwd)/traefik && cd traefik
```
- Baixe o compose do **traefik**
```shell
wget https://raw.githubusercontent.com/JobasFernandes/instalar-traefik-swarm/main/traefik.yaml
```
- Altere as variaveis abaixo dentro do **docker-compose.yaml** com seus dados</BR>

Obs.: Para acessar o dashboard do traefik precisará apontar um subdominio para o **`$IP_DA_VPS`**</BR>
ex: **_traefik.seudominio.com.br_**

1. **`${TRAEFIK_EMAIL}`**
2. **`${TRAEFIK_URL}`**
3. **`${TRAEFIK_CREDS}`**
- As credenciais do traefik podem ser geradas com o comando abaixo substituindo **`$TRAEFIK_EMAIL`** e **`$TRAEFIK_PASS`**
```shell
echo $(htpasswd -nb $TRAEFIK_EMAIL $TRAEFIK_PASS) | sed -e s/\\$/\\$\\$/g
```
- Por fim execute a stack e aguarde o traefik subir
```shell
docker stack deploy --prune --resolve-image always -c traefik.yaml traefik
```
- Acesse o Dashboard do **traefik** **`https://traefik.seudominio.com.br`**
