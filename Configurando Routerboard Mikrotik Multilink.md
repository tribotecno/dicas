# Configurando um Routerboard Mikrotik para provedor multilink com failover e loadbalance #

Recomendamos executar esse tutorial com os vídeos do youtube https://youtu.be/-55BB12tuUM e https://youtu.be/fYZ1haWzJ6o

Para adquirir o Routerboard RB750GR3 utilize os nossos links:

https://s.click.aliexpress.com/e/_oDDbBMv

https://s.click.aliexpress.com/e/_op1d70h

Os passos abaixo são para a versão 6.49.18 do Mikrotik OS e com os modems dos provedores colocados em MODO BRIDGE

1 - Realizar o reset do Routerboard

2 - Apagar as configurações padrão de fábrica usando o Winbox 
```
https://mikrotik.com/download
```
3 - Abrir o terminal para iniciar as configurações

4 - Colocar comentário nas interfaces a serem utilizadas
```
/interface ethernet set [ find default-name=ether1 ] comment="Porta VIVO" l2mtu=1598
/interface ethernet set [ find default-name=ether2 ] comment="Porta PREDIALNET" l2mtu=1598 
/interface ethernet set [ find default-name=ether5 ] comment="PortaINTERNA" l2mtu=1598 rx-flow-control=auto tx-flow-control=auto
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

18 - Liberando um servidor pessoal Nextcloud para acesso da Internet

Passo 1 - Liberar o acesso ao servidor na filtragem do firewall
```
/ip firewall filter add action=accept chain=input comment="Libera XAVANTE" dst-address=192.168.1.33 in-interface=pppoe-predial log=yes protocol=tcp
```
Passo 2 - Cadastrar a regra do NAT para redirecionar a porta externa para a interna do servidor
```
/ip firewall nat add action=dst-nat chain=dstnat comment="Acesso ao Xavante Nextcloud SSL" dst-port=443 in-interface=pppoe-predial log=yes protocol=tcp to-addresses=192.168.1.33 to-ports=443
```
Passo 3 - Cadastrar a exceção no roteamento para o servidor utilizar o mesmo IP de entrada para a saída (teste as opções da diretiva action como explicado no vídeo)
```
/ip route rule add action=lookup-only-in-table comment="XAVANTE via PREDIAL" src-address=192.168.1.33/32 table=TO_WANPREDIAL
```

19 - Forçando um computador a sair apenas por um dos links (geralmente acesso ao bancos necessita essa configuração)
```
/ip route rule add comment="Deskwintribomaloca via vivo" src-address=192.168.1.107/32 table=TO_WANVIVO
```

20 - Forçando um computador a sair por um dos links para determinado IP
```
/ip route rule add comment="Nagios via PREDIAL para Servidor Externo" dst-address=199.200.100.201/32 src-address=192.168.1.35/32 table=TO_WANPREDIAL
```

21 - Forçando parte da rede a sair por um dos links
```
/ip route rule add comment="POOL0 via PREDIAL " src-address=192.168.1.0/26 table=TO_WANPREDIAL
```

22 - Liberando o acesso aos gráficos de tráfego do Routerboard
```
/ip firewall filter add action=accept chain=input connection-state=new limit=100,5:packet log=yes protocol=tcp src-address=192.168.1.0/24 tcp-flags=syn
```





