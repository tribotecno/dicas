#!/bin/bash
# Script para atualizar o Dynu DNS
# by Tribotecno 8jan24
# Verificando os IPs
# Coloque o script no crontab para rodar a cada 15 minutos
# 15 * * * * /home/usuarioseu/atualizadynu.sh
# Os comandos abaixo verificam os IPs e acumulam nas variaveis
IPV4=$(wget -4 -qO- http://ipecho.net/plain | xargs echo)
IPV6=$(wget -6 -qO- http://ipecho.net/plain | xargs echo)
# Troque a variavel abaixo para seu nome de usuario
USUARIO=tribotecno
# Passar a senha como hash MD5 ou sha256
# Para obter use o link https://www.dynu.com/NetworkTools/Hash
# Troque a variavel abaixo para o hash obtido com sua senha
SENHA=48127fcadb7e4d110ed9728f94ecd57d
# Nome cadastrado na Dynu troque para seu host
NOMEDDNS=carajas.freeddns.org

# Comando para atualizar as informacoes na Dynu
wget "https://api.dynu.com/nic/update?hostname=$NOMEDDNS&myip=$IPV4&myipv6=$IPV6&username=$USUARIO&password=$SENHA"
