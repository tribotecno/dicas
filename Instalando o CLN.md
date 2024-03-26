# Passos para Instalação do CLN
0 - Neste tutorial partimos do pressuposto do servidor Ubuntu já estar instalado. Para aprender assistam alguns desses nossos videos no canal:

https://youtu.be/ifIrWBHU8gs

https://youtu.be/zFXTC8Qimf8

https://youtu.be/jVxk6pVgiuI

1 - Instalar os pacotes necessários
```
sudo apt-get install -y software-properties-common
```
2 - Instalar o core do Bitcoin
```
 sudo snap install bitcoin-core
```
3 - Configurar os links simbolicos
```
 sudo ln -s /snap/bitcoin-core/current/bin/bitcoin{d,-cli} /usr/local/bin/
```
4 - Rodar o daemon do Core Bitcoin
```
bitcoind -daemon
```
5 - Verifique a sincronização da blockchain no log
```
tail -f .bitcoin/debug.log
```
6 - Baixar o pacote do CLN pré-compilado para Ubuntu 22.04 
```
wget https://github.com/ElementsProject/lightning/releases/download/v23.08.1/clightning-v23.08.1-Ubuntu-22.04.tar.xz
```
7 - Fazer o check do pacote CLN com as assinaturas
```
wget https://github.com/ElementsProject/lightning/releases/download/v23.08.1/SHA256SUMS
```
```
wget https://github.com/ElementsProject/lightning/releases/download/v23.08.1/SHA256SUMS.asc
```
```
gpg --keyserver keyserver.ubuntu.com --recv-keys 15EE8D6CAB0E7F0CF999BFCBD9200E6CD1ADB8F1
```

A saída do comando será a demonstrada abaixo:

__gpg: /home/nauru/.gnupg/trustdb.gpg: trustdb created__
__gpg: key D9200E6CD1ADB8F1: public key "Rusty Russell <rusty@rustcorp.com.au>" imported__
__gpg: Total number processed: 1__
__gpg:               imported: 1__


```
gpg --verify SHA256SUMS.asc
```
Saída do comando:
gpg: assuming signed data in 'SHA256SUMS'
gpg: Signature made Wed 13 Sep 2023 09:49:33 AM UTC
gpg:                using RSA key 15EE8D6CAB0E7F0CF999BFCBD9200E6CD1ADB8F1
gpg: Good signature from "Rusty Russell <rusty@rustcorp.com.au>" [unknown]

```
sha256sum clightning-v23.08.1-Ubuntu-22.04.tar.xz 
```
Saída do comando:
96d6b78a43b53078d0ca13e2cdb6797ce2846e22d6d0bc580393107699d08119  clightning-v23.08.1-Ubuntu-22.04.tar.xz
```
cat SHA256SUMS |grep clightning-v23.08.1-Ubuntu-22.04.tar.xz
```
Saída do comando para comparar com o check anterior:
96d6b78a43b53078d0ca13e2cdb6797ce2846e22d6d0bc580393107699d08119  clightning-v23.08.1-Ubuntu-22.04.tar.xz

8 - Descompactar o aplicativo
```
sudo tar -xvf clightning-v23.08.1-Ubuntu-22.04.tar.xz -C /usr/local --strip-components=2
```
9 - Instalar outros pacotes necessários
```
sudo apt-get install python3-json5 python3-flask python3-gunicorn  python3-pip
```
```
pip3 install --user flask_restx pyln-client
``` 
10 - Realize a configuração básica do CLN
```
nano ~/.lightning/config
```
11 - Copie o conteúdo abaixo, realizando as alterações adequadas ao seu node
```
##Coloque o nome do seu node
alias=T3R3N4ORG
## Escolha sua cor favorita como hexa code
rgb=FFA500
## Rode `lightningd` em segundo plano como  daemon ao inves de  terminal
## Requer o caminho do `log-file`
daemon
## Saida para o arquivo de Log se não estiver rodando como  terminal
## Requerido no modo de  `daemon`
log-file=/home/nauru/.lightning/lightning.log
## Coloque para debug para mais detalhes na saida do log
log-level=info
```
12 - Com essa configuração acima e com a blockchain sincronizada é possível iniciar o node
```
lightningd
```
13 - Verifique com o comando
```
lightning-cli getinfo
```
A saída obtida será parecida com a abaixo:
{
   "id": "0200b06c4bbce3d733e3631ca9c65fe6cebdf63a6baf76c473e8b9bc6ead545f74",
   "alias": "T3R3N4ORG",
   "color": "ffa500",
   "num_peers": 0,
   "num_pending_channels": 0,
   "num_active_channels": 0,
   "num_inactive_channels": 0,
   "address": [],
   "binding": [
      {
         "type": "ipv6",
         "address": "::",
         "port": 9735
      },
      {
         "type": "ipv4",
         "address": "0.0.0.0",
         "port": 9735
      }
   ],
   "version": "23.08.1",
   "blockheight": 814139,
   "network": "bitcoin",
   "fees_collected_msat": 0,
   "lightning-dir": "/home/nauru/.lightning/bitcoin",
   "our_features": {
      "init": "08a0000a0a69a2",
      "node": "88a0000a0a69a2",
      "channel": "",
      "invoice": "02000002024100"
   }
}

14 - O CLN automaticamente configura a parte da rede para a CLEARNET. Para testar a conectividade vamos usar o node da KRAKEN para isso
```
lightning-cli connect 02f1a8c87607f415c8f22c00593002775941dea48869ce23096af27b0cfdcc0b69@52.13.118.208:9735
```
A saída obtida será como a abaixo:
{
   "id": "02f1a8c87607f415c8f22c00593002775941dea48869ce23096af27b0cfdcc0b69",
   "features": "800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000888a52a1",
   "direction": "out",
   "address": {
      "type": "ipv4",
      "address": "52.13.118.208",
      "port": 9735
   }
}

15 - Realize o teste de ping 
```
lightning-cli ping 02f1a8c87607f415c8f22c00593002775941dea48869ce23096af27b0cfdcc0b69
```
Resultado a ser obtido:
{
   "totlen": 132
}


A seguir temos 3 opções de uso da rede do node: somente CLEARNET, somente TOR e modo híbrido usando a CLEARNET e TOR juntas.

16 - Configuração da rede - Opção somente CLEARNET - coloque as linhas abaixo no arquivo ~/.lightning/config
```
nano
```
```
##
#                              Ajustes da Rede
##
# Configuração  para CLEARNET
## Esse ajuste o node se encontra usando o NAT comum do provedor
## Caso tenha escolhido a porta 9735 a mesma tem que estar aberta no modem
## Se seu modem router estiver usando uPNP nenhum ajuste é necessário no modem
## O CLN possui um mecanismo de descoberta do IP externo
bind-addr=0.0.0.0:9735
```

17 -  Faça o restart do node para aplicar a configuração com o comando
nauru@terenanode:~$ lightning-cli stop && sleep 2 && lightningd

12.2 - Verifique a configuração

nauru@terenanode:~$ lightning-cli getinfo
{
   "id": "0200b06c4bbce3d733e3631ca9c65fe6cebdf63a6baf76c473e8b9bc6ead545f74",
   "alias": "T3R3N4ORG",
   "color": "ffa500",
   "num_peers": 0,
   "num_pending_channels": 0,
   "num_active_channels": 0,
   "num_inactive_channels": 0,
   "address": [],
   "binding": [
      {
         "type": "ipv4",
         "address": "0.0.0.0",
         "port": 9735
      }
   ],
   "version": "23.08.1",
   "blockheight": 814140,
   "network": "bitcoin",
   "fees_collected_msat": 0,
   "lightning-dir": "/home/nauru/.lightning/bitcoin",
   "our_features": {
      "init": "08a0000a0a69a2",
      "node": "88a0000a0a69a2",
      "channel": "",
      "invoice": "02000002024100"
   }
}

13 - Configuração da rede - Opção somente rede TOR - Necessita algumas configurações adicionais

13.1 - Instale o pacote do TOR
nauru@terenanode:~$ sudo apt install tor

13.2 -  Verifique se está rodando corretamente
nauru@terenanode:~$ sudo systemctl status tor
[sudo] password for nauru: 
● tor.service - Anonymizing overlay network for TCP (multi-instance-master)
     Loaded: loaded (/lib/systemd/system/tor.service; enabled; vendor preset: enabled)
     Active: active (exited) since Fri 2023-10-27 20:32:33 UTC; 3h 50min ago
    Process: 819 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 819 (code=exited, status=0/SUCCESS)
        CPU: 870us

Oct 27 20:32:33 terenanode systemd[1]: Starting Anonymizing overlay network for TCP (multi-instance-master)...
Oct 27 20:32:33 terenanode systemd[1]: Finished Anonymizing overlay network for TCP (multi-instance-master).

13.3 - Adicione seu nome de usuário ao grupo do tor

nauru@terenanode:~$ sudo usermod -a -G debian-tor nauru # no caso retire o 'nauru' e coloque seu nome de login

13.4 -  Edite o arquivo do tor 
nauru@terenanode:~$ sudo nano /etc/tor/torrc

13.5 - Retire o # das seguintes linhas ou descomente
ControlPort 9051
CookieAuthentication 1
ExitPolicy reject *:* # no exits allowed ou seja não usam o seu node como router onion

13.6 - Faça o restart do tor para aplicar as configurações
nauru@terenanode:~$ sudo systemctl restart tor

13.7 - Edite o arquivo config colocando as linhas abaixo

# Config para TOR
## Configure proxy/tor for OUTBOUND connections.
proxy=127.0.0.1:9050
bind-addr=0.0.0.0:9735
#Anunciar para rede TOR
addr=statictor:127.0.0.1:9051/torport=9735

## Forçar todas as conexões pela rede TOR pelo proxy/tor
always-use-proxy=true

13.8 - Faça o restart do node para aplicar a configuração com o comando
nauru@terenanode:~$ lightning-cli stop && sleep 2 && lightningd

13.9 - Check as configurações que devem estar parecidas com a saída abaixo

nauru@terenanode:~$ lightning-cli getinfo
{
   "id": "0200b06c4bbce3d733e3631ca9c65fe6cebdf63a6baf76c473e8b9bc6ead545f74",
   "alias": "T3R3N4ORG",
   "color": "ffa500",
   "num_peers": 0,
   "num_pending_channels": 0,
   "num_active_channels": 0,
   "num_inactive_channels": 0,
   "address": [
      {
         "type": "torv3",
         "address": "blc2o4roharpux4iej536hbeqdktczcyvol2z2lbcwvf3qafigwydqid.onion",
         "port": 9735
      }
   ],
   "binding": [
      {
         "type": "ipv4",
         "address": "0.0.0.0",
         "port": 9735
      }
   ],
   "version": "23.08.1",
   "blockheight": 814144,
   "network": "bitcoin",
   "fees_collected_msat": 0,
   "lightning-dir": "/home/nauru/.lightning/bitcoin",
   "our_features": {
      "init": "08a0000a0a69a2",
      "node": "88a0000a0a69a2",
      "channel": "",
      "invoice": "02000002024100"
   }
}

14 - Configuração da rede - Opção modo Híbrido - Usando a CLEARNET e TOR ao mesmo tempo 

14.1 - Edite o arquivo config e insira as informações abaixo. É necessário que as configurações da rede TOR já tenham sido feitas
# Config para TOR CLEARNET
## Configure proxy/tor for OUTBOUND connections.
proxy=127.0.0.1:9050
bind-addr=0.0.0.0:9735
#Anunciar para rede TOR
addr=statictor:127.0.0.1:9051/torport=9735

## Colocando em false o node torna-se híbrido
always-use-proxy=false

14.2 - Realize o restart e confira a nova configuração

nauru@terenanode:~$ lightning-cli getinfo
{
   "id": "0200b06c4bbce3d733e3631ca9c65fe6cebdf63a6baf76c473e8b9bc6ead545f74",
   "alias": "T3R3N4ORG",
   "color": "ffa500",
   "num_peers": 0,
   "num_pending_channels": 0,
   "num_active_channels": 0,
   "num_inactive_channels": 0,
   "address": [
      {
         "type": "torv3",
         "address": "blc2o4roharpux4iej536hbeqdktczcyvol2z2lbcwvf3qafigwydqid.onion",
         "port": 9735
      }
   ],
   "binding": [
      {
         "type": "ipv4",
         "address": "0.0.0.0",
         "port": 9735
      }
   ],
   "version": "23.08.1",
   "blockheight": 814146,
   "network": "bitcoin",
   "fees_collected_msat": 0,
   "lightning-dir": "/home/nauru/.lightning/bitcoin",
   "our_features": {
      "init": "08a0000a0a69a2",
      "node": "88a0000a0a69a2",
      "channel": "",
      "invoice": "02000002024100"
   }
}

14.3 - Caso possua um IPv4 fixo pode acrescentar a linha no exemplo abaixo

announce-addr=103.195.101.174:9735

14.4 - A saida de teste será como abaixo

nauru@terenanode:~$ lightning-cli getinfo
{
   "id": "0200b06c4bbce3d733e3631ca9c65fe6cebdf63a6baf76c473e8b9bc6ead545f74",
   "alias": "T3R3N4ORG",
   "color": "ffa500",
   "num_peers": 0,
   "num_pending_channels": 0,
   "num_active_channels": 0,
   "num_inactive_channels": 0,
   "address": [
      {
         "type": "ipv4",
         "address": "103.195.101.174",
         "port": 9735
      },
      {
         "type": "torv3",
         "address": "blc2o4roharpux4iej536hbeqdktczcyvol2z2lbcwvf3qafigwydqid.onion",
         "port": 9735
      }
   ],
   "binding": [
      {
         "type": "ipv4",
         "address": "0.0.0.0",
         "port": 9735
      }
   ],
   "version": "23.08.1",
   "blockheight": 814147,
   "network": "bitcoin",
   "fees_collected_msat": 0,
   "lightning-dir": "/home/nauru/.lightning/bitcoin",
   "our_features": {
      "init": "08a0000a0a69a2",
      "node": "88a0000a0a69a2",
      "channel": "",
      "invoice": "02000002024100"
   }
   
Como proteger a Seed do Node

1 - A seed está localizada na pasta

˜/.lightning/bitcoin/hsm_secret

machado@terenanode:~$ cd .lightning/bitcoin/
machado@terenanode:~/.lightning/bitcoin$ ls
accounts.sqlite3  ca.pem          client.pem         gossip_store          hsm_secret     lightningd.sqlite3  server.pem
ca-key.pem        client-key.pem  emergency.recover  gossip_store.corrupt  lightning-rpc  server-key.pem

2 - Para verificar o conteúdo da seed
xxd hsm_secret

3 - Para fazer o backup da chave
 cat > hsm_secret.bak <<END

Copie e cole as linhas do comando de 2

4 - Para restaurar
 xxd -r hsm_secret.bak > hsm_secret
 
5 - A seed tem que estar apenas leitura
 chmod 400 hsm_secret

6 - Para gerar uma seed pessoal com script de entropia
6.1 - Baixe um script da coldcard
 wget https://coldcard.com/docs/rolls.py
6.2 - Gere as palavras da seed
 echo '23123125534534534534377676768877' | python3 rolls.py
6.3 - Com as palavras BIP39 em mãos, proceda com a criação da hsm_secret
 lightning-hsmtool generatehsm hsm_secret

6.4 - Como visto no procedimento anterior, foi solicitada uma senha para encriptar a seed. Caso não tenha fornecido, o procedimento pode ser feito com o comando

lightning-hsmtool  encrypt hsm_secret 

6.5 - Para o node poder iniciar a seguinte linha deve ser acrescentada no arquivo config do node
 --encrypted-hsm

6.6 - Quando iniciar o node ele abrirá o prompt para entrada da senha e prosseguir com a inicialização

Instalando RTL no CLN

1 - Instalar o C-Lightning-REST

PGP Key:  https://keybase.io/suheb
Download the release and signature:
wget https://github.com/Ride-The-Lightning/c-lightning-REST/archive/refs/tags/v0.10.7.tar.gz
wget https://github.com/Ride-The-Lightning/c-lightning-REST/releases/download/v0.10.7/v0.10.7.tar.gz.asc
Verify the release:
gpg --verify v0.10.7.tar.gz.asc v0.10.7.tar.gz

machado@terenanode:~$ gpg --verify v0.10.7.tar.gz.asc v0.10.7.tar.gz
gpg: Signature made Sat Oct  7 21:05:39 2023 UTC
gpg:                using RSA key 3E9BD4436C288039CA827A9200C9E2BC2E45666F
gpg: Good signature from "saubyk (added uid) <39208279+saubyk@users.noreply.github.com>" [unknown]
gpg:                 aka "Suheb <39208279+saubyk@users.noreply.github.com>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 3E9B D443 6C28 8039 CA82  7A92 00C9 E2BC 2E45 666F

2 - Comandos

467  wget https://github.com/Ride-The-Lightning/c-lightning-REST/archive/refs/tags/v0.10.7.tar.gz
  468  ls
  469  wget https://github.com/Ride-The-Lightning/c-lightning-REST/releases/download/v0.10.7/v0.10.7.tar.gz.asc
  470  gpg --verify v0.10.7.tar.gz.asc v0.10.7.tar.gz
  471  sudo su -
  472  sudo apt-get update
  473  sudo apt-get install -y ca-certificates curl gnupg
  474  sudo mkdir -p /etc/apt/keyrings
  475  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
  476  NODE_MAJOR=20
  477  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
  478  sudo apt-get update
  479  sudo apt-get install nodejs -y
  480  mkdir ~/.npm-global
  481  npm config set prefix '~/.npm-global'
  482  nano .profile 

export PATH="$HOME/.npm-global/bin:$PATH" ### Append to ~/.profile

  483  source ~/.profile
  484  curl https://keybase.io/suheb/pgp_keys.asc | gpg --import
  485  gpg --verify v0.10.7.tar.gz.asc v0.10.7.tar.gz
  486  ls
  487  tar -xzf v0.10.7.tar.gz 
  488  ls
  489  cd c-lightning-REST-0.10.7/
  490  cp sample-cl-rest-config.json cl-rest-config.json 
  491  cat cl-rest-config.json 
  492  npm install
  493  node cl-rest.js

Testar para ver se está rodando

machado@terenanode:~$ lsof -i -P -n | grep LISTEN
bitcoind   2023 machado   11u  IPv6  22335      0t0  TCP [::1]:8332 (LISTEN)
bitcoind   2023 machado   12u  IPv4  22337      0t0  TCP 127.0.0.1:8332 (LISTEN)
bitcoind   2023 machado   26u  IPv4  22340      0t0  TCP 127.0.0.1:8334 (LISTEN)
bitcoind   2023 machado   27u  IPv6  22341      0t0  TCP *:8333 (LISTEN)
bitcoind   2023 machado   28u  IPv4  22342      0t0  TCP *:8333 (LISTEN)
lightning  4305 machado    5u  IPv4  45563      0t0  TCP *:9735 (LISTEN)
node      22089 machado   28u  IPv6 171408      0t0  TCP *:3001 (LISTEN)
node      22089 machado   29u  IPv6 171409      0t0  TCP *:4001 (LISTEN)


467  cd c-lightning-REST-0.10.7/
  468  ls
  469  cd certs/

machado@terenanode:~/c-lightning-REST-0.10.7/certs$ ls
access.macaroon  certificate.pem  key.pem  rootKey.key

Baixar o RTL
 wget https://github.com/Ride-The-Lightning/RTL/archive/refs/tags/v0.14.1.tar.gz
 wget https://github.com/Ride-The-Lightning/RTL/releases/download/v0.14.1/v0.14.1.tar.gz.asc

Testar
machado@terenanode:~$ gpg --verify v0.14.1.tar.gz.asc v0.14.1.tar.gz
gpg: Signature made Sat Oct  7 21:41:32 2023 UTC
gpg:                using RSA key 3E9BD4436C288039CA827A9200C9E2BC2E45666F
gpg: Good signature from "saubyk (added uid) <39208279+saubyk@users.noreply.github.com>" [unknown]
gpg:                 aka "Suheb <39208279+saubyk@users.noreply.github.com>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 3E9B D443 6C28 8039 CA82  7A92 00C9 E2BC 2E45 666F


Descompactar
 tar -xzf v0.14.1.tar.gz
 cd RTL
 npm install --only-prod --legacy-peer-deps

Configurar
 cp Sample-RTL-Config.json RTL-Config.json
 nano RTL-Config.json

machado@terenanode:~/c-lightning-REST-0.10.7/certs$ cd
machado@terenanode:~$ cd .lightning/
machado@terenanode:~/.lightning$ mkdir rtl-backup
machado@terenanode:~/.lightning$ cd rtl-backup/
machado@terenanode:~/.lightning/rtl-backup$ pwd
/home/machado/.lightning/rtl-backup


Para executar
machado@terenanode:~/RTL-0.14.1$ node rtl
[10/28/2023, 9:54:29 PM] INFO: RTL => Server is up and running, please open the UI at http://localhost:3000 or your proxy configured url.

machado@terenanode:~/.lightning/rtl-backup$ lsof -i -P -n | grep LISTEN
bitcoind   2023 machado   11u  IPv6  22335      0t0  TCP [::1]:8332 (LISTEN)
bitcoind   2023 machado   12u  IPv4  22337      0t0  TCP 127.0.0.1:8332 (LISTEN)
bitcoind   2023 machado   26u  IPv4  22340      0t0  TCP 127.0.0.1:8334 (LISTEN)
bitcoind   2023 machado   27u  IPv6  22341      0t0  TCP *:8333 (LISTEN)
bitcoind   2023 machado   28u  IPv4  22342      0t0  TCP *:8333 (LISTEN)
lightning  4305 machado    5u  IPv4  45563      0t0  TCP *:9735 (LISTEN)
node      22244 machado   28u  IPv6 171462      0t0  TCP *:3001 (LISTEN)
node      22244 machado   29u  IPv6 171463      0t0  TCP *:4001 (LISTEN)
node      22900 machado   25u  IPv6 173507      0t0  TCP *:3000 (LISTEN)

Os plugins trazem mais funcionalidade para a administração do node

1 - Acesse o github dos plugins e realize a clonagem
 git clone https://github.com/lightningd/plugins.git

2 - Pare o node
 lightning-cli stop

3 - Entre na pasta do CLN
 cd .lightning/

4 - Mova os plugins para dentro da pasta
 mv ˜/plugins/ plugins-available

5 - Crie a pasta dos plugins que serão ativados
 mkdir plugins-enabled

6 - Entre na pasta dos plugins
 cd plugins-available/

7 - Vamos escolher um plugin de exemplo: o summary
 cd summary/
 pip3 install --user -r requirements.txt
 pip3 install --user pyln-bolt1 pyln-bolt2 pyln-bolt4 pyln-bolt7 pyln-client pyln-proto

8 - Insira a linha no arquivo config onde estarão os plugins ativados
 # plugins
 plugin-dir=/home/machado/.lightning/plugins-enabled

9 - Crie agora o link simbolico para ativar o plugin
 cd plugins-enabled
 ln -s /home/machado/.lightning/plugins-available/summary/summary.py ./summary.py

10 - Inicie o CLN
 lightningd

11 - Para testar execute o comando no plugin
 lightning-cli -H summary

12 - Para remover o plugin execute os comandos
 lightning-cli  stop
 rm .lightning/plugins-enabled/summary.py
 lightningd

Backup dos Canais no CLN
Para manter um backup de segurança dos seus canais, um ponto de montagem diferente do seu disco normal pode ser usado. Por exemplo um pendrive de boa capacidade.
Os seguintes procedimentos devem ser realizados

1 - Monte o disco ou pendrive no seu node

2 - A seguinte linha deve ser adicionada no seu arquivo config alterando apropriadamente os seus apontamentos
# backup wallet=sqlite3:///home/machado/.lightning/bitcoin/lightningd.sqlite3:/media/pen128gb/backup/lightningd.sqlite3 

3 - Realize o restart do node

É o mesmo que na instalação

wget https://github.com/ElementsProject/lightning/releases/download/v23.11/clightning-v23.11-Ubuntu-22.04.tar.xz

Stop CLN daemon

sudo tar -xvf <release>.tar.xz -C /usr/local --strip-components=2

De <https://github.com/ElementsProject/lightning/blob/master/doc/getting-started/getting-started/installation.md> 

#Rodar com o comando abaixo pois não vai
lightningd --database-upgrade=true

Instalando NGIX para acesso seguro RTL CLN

