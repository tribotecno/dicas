#!/bin/bash
echo "Meu IPv4:"
wget -4 -qO- http://ipecho.net/plain | xargs echo
echo "Meu IPv6:"
wget -6 -qO- http://ipecho.net/plain | xargs echo
echo "====================="
echo "====================="
echo "Verificando contra o DNS externo 1.1.1.1"
dig +short carajas.freeddns.org A carajas.freeddns.org AAAA @1.1.1.1
echo "Verificando contra o DNS externo 8.8.8.8"
dig +short carajas.freeddns.org A carajas.freeddns.org AAAA @8.8.8.8
