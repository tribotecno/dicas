# Configurando um Routerboard Mikrotik para provedor multilink com failover e loadbalance #
Recomendamos executar esse tutorial com o vídeo do youtube

Para adquirir o Routerboard RB750GR3 utilize os nossos links:

https://s.click.aliexpress.com/e/_oDDbBMv

https://s.click.aliexpress.com/e/_op1d70h

Os passos abaixo são para a versão 7 do Mikrotik OS e com os modems dos provedores colocados em MODO BRIDGE

1 - Realizar o reset do Routerboard

2 - Apagar as configurações padrão de fábrica

3 - Abrir o terminal para iniciar as configurações

4 - Colocar comentário nas interfaces a serem utilizadas
```
/interface ethernet set [ find default-name=ether1 ] comment="Porta VIVO" l2mtu=1598
/interface ethernet set [ find default-name=ether2 ] comment="Porta PREDIALNET" l2mtu=1598 
/interface ethernet set [ find default-name=ether5 ] advertise=10M-half,10M-full,100M-half,100M-full,1000M-half,1000M-full,2500M-full,5000M-full,10000M-full comment="PortaINTERNA" l2mtu=1598 rx-flow-control=auto tx-flow-control=auto
```
5 - Configurar as conexões PPOE (ajuste os logins de acordo com o seu provedor internet)
```
/interface pppoe-client add comment="PPOE PREDIALNET" disabled=no interface=ether2 name=pppoe-predial password=####### user=#####@predialnet.com.br
/interface pppoe-client add comment="PPOE VIVO" disabled=no interface=ether1 name=pppoe-vivo password=##### user=cliente@cliente
```
6 - Criar os nomes para a rede interna e externa
```
/interface list add comment=defconf name=WAN
/interface list add comment=defconf name=LAN
```
7 - Configurações padrão de log e tracking
```
/system logging action set 1 disk-file-name=log
/ip firewall connection tracking set enabled=yes
/ip neighbor discovery-settings set discover-interface-list=!dynamic
/ip settings set accept-redirects=yes tcp-syncookies=yes
```
8 - Atribuir os nomes para a rede interna e externas nas interfaces
```
/interface list member add comment=defconf interface=ether5 list=LAN
/interface list member add interface=pppoe-predial list=WAN
/interface list member add interface=pppoe-vivo list=WAN
```
9 - Configurar o IP da Rede Interna
```
/ip address add address=192.168.1.10/24 interface=ether5 network=192.168.1.0
```
10 - Acertar o DNS do Routerboard
```
/ip dns set cache-size=4192KiB max-concurrent-queries=300 max-concurrent-tcp-sessions=60 servers=192.168.1.11,1.1.1.1,8.8.8.8
```
11 - Proteção básica da rede
```
/ip firewall filter add action=accept chain=input connection-state=new limit=100,5:packet log=yes protocol=tcp tcp-flags=syn
/ip firewall filter add action=drop chain=input connection-state=new log=yes protocol=tcp tcp-flags=syn
/ip firewall filter add action=drop chain=input connection-limit=30,32 log=yes protocol=tcp tcp-flags=syn
/ip firewall service-port set tftp disabled=yes
/ip firewall service-port set irc disabled=yes
/ip firewall service-port set sip disabled=yes
```
12 - Ajustando a marcação de pacotes para o loadbalance
```
/ip firewall mangle add action=accept chain=prerouting in-interface=pppoe-predial
/ip firewall mangle add action=accept chain=prerouting in-interface=pppoe-vivo
/ip firewall mangle add action=mark-connection chain=prerouting dst-address-type=!local new-connection-mark=WANPREDIAL_CONN passthrough=yes per-connection-classifier=both-addresses-and-ports:2/0 src-address=192.168.1.0/24
/ip firewall mangle add action=mark-connection chain=prerouting dst-address-type=!local new-connection-mark=WANVIVO_CONN per-connection-classifier=both-addresses-and-ports:2/1 src-address=192.168.1.0/24
/ip firewall mangle add action=mark-routing chain=prerouting connection-mark=WANPREDIAL_CONN new-routing-mark=TO_WANPREDIAL passthrough=yes src-address=192.168.1.0/24
/ip firewall mangle add action=mark-routing chain=prerouting connection-mark=WANVIVO_CONN new-routing-mark=TO_WANVIVO src-address=192.168.1.0/24
```
13 - Habilitando o NAT
```
/ip firewall nat add action=masquerade chain=srcnat out-interface=pppoe-predial src-address=192.168.1.0/24
/ip firewall nat add action=masquerade chain=srcnat out-interface=pppoe-vivo src-address=192.168.1.0/24
```
14 - Ajustando o roteamento para o failover
```
/ip route add check-gateway=ping distance=1 gateway=pppoe-predial routing-mark=TO_WANPREDIAL
/ip route add check-gateway=ping distance=1 gateway=pppoe-vivo routing-mark=TO_WANVIVO
/ip route add check-gateway=ping distance=1 gateway=pppoe-predial
/ip route add check-gateway=ping distance=2 gateway=pppoe-vivo
```
15 - Proteção de acesso ao Routerboard
```
/ip service set telnet disabled=yes
/ip service set ftp disabled=yes
/ip service set www address=192.168.1.0/24
/ip service set ssh address=192.168.1.0/24
/ip service set api address=192.168.1.0/24
/ip service set winbox address=192.168.1.0/24
/ip service set api-ssl address=192.168.1.0/24
```
16 - Outras configurações úteis
```
/system clock set time-zone-name=America/Sao_Paulo
/system identity set name=RBJG
/system logging add topics=lte
/system ntp client set enabled=yes primary-ntp=200.160.0.8 secondary-ntp=200.189.40.8
/tool bandwidth-server set authenticate=no enabled=no
/tool graphing interface add allow-address=192.168.1.0/24
/tool graphing resource add allow-address=192.168.1.0/24
```
17 - Realize os teste necessários de conexão como demonstrado no vídeo


