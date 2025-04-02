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


