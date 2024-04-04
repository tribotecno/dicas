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


`gpg: /home/nauru/.gnupg/trustdb.gpg: trustdb created`<br>
`gpg: key D9200E6CD1ADB8F1: public key "Rusty Russell <rusty@rustcorp.com.au>" imported`<br>
`gpg: Total number processed: 1`<br>
`gpg:               imported: 1` <br>


```
gpg --verify SHA256SUMS.asc
```
Saída do comando:

`gpg: assuming signed data in 'SHA256SUMS'`<br>
 `gpg: Signature made Wed 13 Sep 2023 09:49:33 AM UTC`<br>
 `gpg:                using RSA key 15EE8D6CAB0E7F0CF999BFCBD9200E6CD1ADB8F1`<br>
`gpg: Good signature from "Rusty Russell <rusty@rustcorp.com.au>" [unknown]`<br>

```
sha256sum clightning-v23.08.1-Ubuntu-22.04.tar.xz 
```
Saída do comando:

`96d6b78a43b53078d0ca13e2cdb6797ce2846e22d6d0bc580393107699d08119  clightning-v23.08.1-Ubuntu-22.04.tar.xz`

```
cat SHA256SUMS |grep clightning-v23.08.1-Ubuntu-22.04.tar.xz
```
Saída do comando para comparar com o check anterior:

`96d6b78a43b53078d0ca13e2cdb6797ce2846e22d6d0bc580393107699d08119  clightning-v23.08.1-Ubuntu-22.04.tar.xz`

8 - Descompactar o aplicativo
```
sudo tar -xvf clightning-v23.08.1-Ubuntu-22.04.tar.xz -C /usr/local --strip-components=2
```
9 - Instalar outros pacotes necessários
```
sudo apt-get install python3-json5 python3-flask python3-gunicorn  python3-pip libpq-dev
```
```
pip3 install --user flask-cors flask_restx pyln-client flask-socketio gevent gevent-websocket
``` 
10 - Realize a configuração básica do CLN
Rode primeiro o comando abaixo:
```
lightningd --network=bitcoin --log-level=debug
```
Caso tudo esteja correto dê um Crtl-C para interromper e realizar as configurações seguintes:
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

`{`<br>
`   "id": "0200b06c4bbce3d733e3631ca9c65fe6cebdf63a6baf76c473e8b9bc6ead545f74",`<br>
`   "alias": "T3R3N4ORG",`<br>
`   "color": "ffa500",`<br>
`   "num_peers": 0,`<br>
`   "num_pending_channels": 0,`<br>
`   "num_active_channels": 0,`<br>
`   "num_inactive_channels": 0,`<br>
`   "address": [],`<br>
`   "binding": [],`<br>
`  {`<br>
`         "type": "ipv6",`<br>
`         "address": "::",`<br>
`         "port": 9735`<br>
`      },`<br>
`      {`<br>
`         "type": "ipv4",`<br>
`         "address": "0.0.0.0",`<br>
`         "port": 9735`<br>
`      }`<br>
`   ],`<br>
`   "version": "23.08.1",`<br>
`   "blockheight": 814139,`<br>
`   "network": "bitcoin",`<br>
`   "fees_collected_msat": 0,`<br>
`   "lightning-dir": "/home/nauru/.lightning/bitcoin",`<br>
`   "our_features": {`<br>
`      "init": "08a0000a0a69a2",`<br>
`      "node": "88a0000a0a69a2",`<br>
`      "channel": "",`<br>
`      "invoice": "02000002024100"`<br>
`   }`<br>
`}`

14 - O CLN automaticamente configura a parte da rede para a CLEARNET. Para testar a conectividade vamos usar o node da KRAKEN para isso:
```
lightning-cli connect 02f1a8c87607f415c8f22c00593002775941dea48869ce23096af27b0cfdcc0b69@52.13.118.208:9735
```
A saída obtida será como a abaixo:


 `{`<br>
   `"id": "02f1a8c87607f415c8f22c00593002775941dea48869ce23096af27b0cfdcc0b69",`<br>
   `"features":`<br> `"80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000>0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000888a52a1",`<br>
   `"direction": "out",`<br>
   `"address": {`<br>
      `"type": "ipv4",`<br>
      `"address": "52.13.118.208",`<br>
      `"port": 9735`<br>
   `}`<br>
`}`<br>


15 - Realize o teste de ping 
```
lightning-cli ping 02f1a8c87607f415c8f22c00593002775941dea48869ce23096af27b0cfdcc0b69
```
Resultado a ser obtido:
>{
>   "totlen": 132
>}


A seguir temos 3 opções de uso da rede do node: somente CLEARNET, somente TOR e modo híbrido usando a CLEARNET e TOR juntas.

16 - Configuração da rede - Opção somente CLEARNET - coloque as linhas abaixo no arquivo ~/.lightning/config
```
nano ~/.lightning/config
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
```
lightning-cli stop && sleep 2 && lightningd
```
18 - Verifique a configuração
```
lightning-cli getinfo
```
A saída do comando:
`
{<br>
   "id": "0200b06c4bbce3d733e3631ca9c65fe6cebdf63a6baf76c473e8b9bc6ead545f74",<br>
   "alias": "T3R3N4ORG",<br>
   "color": "ffa500",<br>
   "num_peers": 0,<br>
   "num_pending_channels": 0,<br>
   "num_active_channels": 0,<br>
   "num_inactive_channels": 0,<br>
   "address": [],<br>
   "binding": []<br>
      {<br>
         "type": "ipv4",<br>
         "address": "0.0.0.0",<br>
         "port": 9735<br>
      }<br>
   ],<br>
   "version": "23.08.1",<br>
   "blockheight": 814140,<br>
   "network": "bitcoin",<br>
   "fees_collected_msat": 0,<br>
   "lightning-dir": "/home/nauru/.lightning/bitcoin",<br>
   "our_features": {<br>
      "init": "08a0000a0a69a2",<br>
      "node": "88a0000a0a69a2",<br>
      "channel": "",<br>
      "invoice": "02000002024100"<br>
   }<br>
}<br>
`

19 - Configuração da rede - Opção somente rede TOR - Necessita algumas configurações adicionais

20 - Instale o pacote do TOR
```
sudo apt install tor
```
21 -  Verifique se está rodando corretamente
```
sudo systemctl status tor
```
Saída do comando: 
`
> [sudo] password for nauru:
> 
> tor.service - Anonymizing overlay network for TCP (multi-instance-master)
>
>  Loaded: loaded (/lib/systemd/system/tor.service; enabled; vendor preset: enabled)
>
>  Active: active (exited) since Fri 2023-10-27 20:32:33 UTC; 3h 50min ago
> 
>  Process: 819 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
> 
>  Main PID: 819 (code=exited, status=0/SUCCESS)
> 
>  CPU: 870us
>
>Oct 27 20:32:33 terenanode systemd[1]: Starting Anonymizing overlay network for TCP (multi-instance-master)...
> 
>Oct 27 20:32:33 terenanode systemd[1]: Finished Anonymizing overlay network for TCP (multi-instance-master).
`
22 - Adicione seu nome de usuário ao grupo do tor
```
sudo usermod -a -G debian-tor nauru # no caso retire o 'nauru' e coloque seu nome de login
```
23 -  Edite o arquivo do tor 
```
sudo nano /etc/tor/torrc
```
24 - Retire o # das seguintes linhas ou descomente:
```
ControlPort 9051
CookieAuthentication 1
ExitPolicy reject *:* # no exits allowed ou seja não usam o seu node como router onion
```
25 - Faça o restart do tor para aplicar as configurações
```
sudo systemctl restart tor
```
26 - Edite o arquivo config colocando as linhas abaixo
```
nano ~/.lightning/config
```
```
# Config para TOR
## Configure proxy/tor for OUTBOUND connections.
proxy=127.0.0.1:9050
bind-addr=0.0.0.0:9735
#Anunciar para rede TOR
addr=statictor:127.0.0.1:9051/torport=9735
## Forçar todas as conexões pela rede TOR pelo proxy/tor
always-use-proxy=true
```
27 - Faça o restart do node para aplicar a configuração com o comando
```
lightning-cli stop && sleep 2 && lightningd
```
28 - Check as configurações que devem estar parecidas com a saída abaixo
```
lightning-cli getinfo
```
Saída do comando:
>{
>   "id": "0200b06c4bbce3d733e3631ca9c65fe6cebdf63a6baf76c473e8b9bc6ead545f74",
>   "alias": "T3R3N4ORG",
>   "color": "ffa500",
>   "num_peers": 0,
>   "num_pending_channels": 0,
>   "num_active_channels": 0,
>   "num_inactive_channels": 0,
>   "address": []
>      {
>         "type": "torv3",
>         "address": "blc2o4roharpux4iej536hbeqdktczcyvol2z2lbcwvf3qafigwydqid.onion",
>         "port": 9735
>      }
>   ],
>   "binding": []
>      {
>         "type": "ipv4",
>         "address": "0.0.0.0",
>         "port": 9735
>      }
>   ],
>   "version": "23.08.1",
>   "blockheight": 814144,
>   "network": "bitcoin",
>   "fees_collected_msat": 0,
>   "lightning-dir": "/home/nauru/.lightning/bitcoin",
>   "our_features": {
>      "init": "08a0000a0a69a2",
>      "node": "88a0000a0a69a2",
>      "channel": "",
>      "invoice": "02000002024100"
>   }
>}

29 - Configuração da rede - Opção modo Híbrido - Usando a CLEARNET e TOR ao mesmo tempo 

30 - Edite o arquivo config e insira as informações abaixo. É necessário que as configurações da rede TOR já tenham sido feitas
```
nano ~/.lightning/config
```
```
# Config para TOR CLEARNET
## Configure proxy/tor for OUTBOUND connections.
proxy=127.0.0.1:9050
bind-addr=0.0.0.0:9735
#Anunciar para rede TOR
addr=statictor:127.0.0.1:9051/torport=9735
## Colocando em false o node torna-se híbrido
always-use-proxy=false
```
31 - Realize o restart e confira a nova configuração
```
lightning-cli getinfo
```
Saída do comando:
>{
>   "id": "0200b06c4bbce3d733e3631ca9c65fe6cebdf63a6baf76c473e8b9bc6ead545f74",
>   "alias": "T3R3N4ORG",
>   "color": "ffa500",
>   "num_peers": 0,
>   "num_pending_channels": 0,
>   "num_active_channels": 0,
>   "num_inactive_channels": 0,
>   "address": [
>      {
>         "type": "torv3",
>         "address": "blc2o4roharpux4iej536hbeqdktczcyvol2z2lbcwvf3qafigwydqid.onion",
>         "port": 9735
>      }
>   ],
>   "binding": [
>      {
>         "type": "ipv4",
>         "address": "0.0.0.0",
>         "port": 9735
>      }
>   ],
>   "version": "23.08.1",
>   "blockheight": 814146,
>   "network": "bitcoin",
>   "fees_collected_msat": 0,
>   "lightning-dir": "/home/nauru/.lightning/bitcoin",
>   "our_features": {
>      "init": "08a0000a0a69a2",
>      "node": "88a0000a0a69a2",
>      "channel": "",
>      "invoice": "02000002024100"
>   }
>}

32 - Caso possua um IPv4 fixo pode acrescentar a linha no exemplo abaixo
```
announce-addr=103.195.101.174:9735
```
A saida de teste será como abaixo
```
lightning-cli getinfo
```
>{
>   "id": "0200b06c4bbce3d733e3631ca9c65fe6cebdf63a6baf76c473e8b9bc6ead545f74",
>   "alias": "T3R3N4ORG",
>   "color": "ffa500",
>   "num_peers": 0,
>   "num_pending_channels": 0,
>   "num_active_channels": 0,
>   "num_inactive_channels": 0,
>   "address": [
>      {
>         "type": "ipv4",
>         "address": "103.195.101.174",
>         "port": 9735
>      },
>      {
>         "type": "torv3",
>         "address": "blc2o4roharpux4iej536hbeqdktczcyvol2z2lbcwvf3qafigwydqid.onion",
>         "port": 9735
>      }
>   ],
>   "binding": [
>      {
>         "type": "ipv4",
>         "address": "0.0.0.0",
>         "port": 9735
>      }
>   ],
>   "version": "23.08.1",
>   "blockheight": 814147,
>   "network": "bitcoin",
>   "fees_collected_msat": 0,
>   "lightning-dir": "/home/nauru/.lightning/bitcoin",
>   "our_features": {
>      "init": "08a0000a0a69a2",
>      "node": "88a0000a0a69a2",
>      "channel": "",
>      "invoice": "02000002024100"
>   }
   
## Como proteger a Seed do Node

33 - A seed está localizada na pasta
```
cd  .lightning/bitcoin/
ls -la hsm_secret
```
34 - Para verificar o conteúdo da seed
```
xxd hsm_secret
```
35 - Para fazer o backup da chave
```
 cat > hsm_secret.bak <<END
```
Copie e cole as linhas do comando

36 - Para restaurar
```
 xxd -r hsm_secret.bak > hsm_secret
``` 
37 - A seed tem que estar apenas leitura
```
 chmod 400 hsm_secret
```
## Atenção, os passos abaixo alteram o endereço da carteira. Faça apenas se tiver instalando um node NOVO!!!
Execute antes os passos abaixo de apagar a hsm_secret e o arquivo da carteira:
```
cd .lightning/bitcoin/
lightning-cli stop
rm hsm_secret
rm lightningd.sqlite3
```
38 - Para gerar uma seed pessoal com script de entropia, baixe um script da coldcard:
```
 wget https://coldcard.com/docs/rolls.py
```
39 - Gere as palavras da seed (não esquece de acrescentar mais números para gerar entropia diferente):
```
 echo '23123125534534534534377676768877' | python3 rolls.py
```
40 - Com as palavras BIP39 em mãos, proceda com a criação da hsm_secret
```
 lightning-hsmtool generatehsm hsm_secret
```
41 - Como visto no procedimento anterior, foi solicitada uma senha para encriptar a seed. Caso não tenha fornecido, o procedimento pode ser feito com o comando
```
lightning-hsmtool  encrypt hsm_secret 
```
42 - Para o node poder iniciar a seguinte linha deve ser acrescentada no arquivo config do node
```
encrypted-hsm
```
43 - Quando iniciar o node ele abrirá o prompt para entrada da senha e prosseguir com a inicialização

## Instalando o Ride The Lightning (RTL) no CLN

44 - Instalar o C-Lightning-REST, baixando o release e assinatura:
```
wget https://github.com/Ride-The-Lightning/c-lightning-REST/archive/refs/tags/v0.10.7.tar.gz
wget https://github.com/Ride-The-Lightning/c-lightning-REST/releases/download/v0.10.7/v0.10.7.tar.gz.asc
```
45 - Para configurar o GPG para o check, execute os comandos abaixo:
```
sudo apt-get update
```
```
sudo apt-get install -y ca-certificates curl gnupg
```
```
sudo mkdir -p /etc/apt/keyrings
```
```
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
```
```
NODE_MAJOR=20
```
```
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
```
```
sudo apt-get update
```
```
sudo apt-get install nodejs -y
```
```
mkdir ~/.npm-global
```
```
npm config set prefix '~/.npm-global'
```
```
nano .profile 
```
Inclua a linha no final do arquivo:
```
export PATH="$HOME/.npm-global/bin:$PATH" ### Append to ~/.profile
```
```
source ~/.profile
```
```
curl https://keybase.io/suheb/pgp_keys.asc | gpg --import
```
46 - Verificando a assinaturas:
```
gpg --verify v0.10.7.tar.gz.asc v0.10.7.tar.gz
```
Saida do comando: 
>gpg: Signature made Sat Oct  7 21:05:39 2023 UTC
>gpg:                using RSA key 3E9BD4436C288039CA827A9200C9E2BC2E45666F
>gpg: Good signature from "saubyk (added uid) <39208279+saubyk@users.noreply.github.com>" [unknown]
>gpg:                 aka "Suheb <39208279+saubyk@users.noreply.github.com>" [unknown]
>gpg: WARNING: This key is not certified with a trusted signature!
>gpg:          There is no indication that the signature belongs to the owner.
>Primary key fingerprint: 3E9B D443 6C28 8039 CA82  7A92 00C9 E2BC 2E45 666F

47 - Descompactando o arquivo
```
tar -xzf v0.10.7.tar.gz 
```
48 - Entre na pasta descompactada:
```
cd c-lightning-REST-0.10.7/
```
49 - Copie o arquivo exemplo para o original:
```
cp sample-cl-rest-config.json cl-rest-config.json 
```
50 - Verifique se está tudo correto:
```
cat cl-rest-config.json 
```
51 - Realize a instalação dos pacotes npm
```
npm install
```
52 - Execute o serviço:
```
node cl-rest.js
```
53 - Testar para ver se está rodando corretamente:
```
lsof -i -P -n | grep LISTEN
```
A saída deve ter as portas 3001 e 4001 presentes:

> bitcoind   2023 nauru   11u  IPv6  22335      0t0  TCP [::1]:8332 (LISTEN)
>
> bitcoind   2023 nauru   12u  IPv4  22337      0t0  TCP 127.0.0.1:8332 (LISTEN)
>
> bitcoind   2023 nauru   26u  IPv4  22340      0t0  TCP 127.0.0.1:8334 (LISTEN)
> 
> bitcoind   2023 nauru   27u  IPv6  22341      0t0  TCP *:8333 (LISTEN)
> 
> bitcoind   2023 nauru   28u  IPv4  22342      0t0  TCP *:8333 (LISTEN)
>
> lightning  4305 nauru    5u  IPv4  45563      0t0  TCP *:9735 (LISTEN)
>
> node      22089 nauru   28u  IPv6 171408      0t0  TCP *:3001 (LISTEN)
>
> node      22089 nauru   29u  IPv6 171409      0t0  TCP *:4001 (LISTEN)

54 - Baixar o RTL
```
 wget https://github.com/Ride-The-Lightning/RTL/archive/refs/tags/v0.14.1.tar.gz
 wget https://github.com/Ride-The-Lightning/RTL/releases/download/v0.14.1/v0.14.1.tar.gz.asc
```
55 - Realizar a verificação do pacote
```
gpg --verify v0.14.1.tar.gz.asc v0.14.1.tar.gz
```
A saída deverá ser a abaixo:
>gpg: Signature made Sat Oct  7 21:41:32 2023 UTC
>gpg:                using RSA key 3E9BD4436C288039CA827A9200C9E2BC2E45666F
>gpg: Good signature from "saubyk (added uid) <39208279+saubyk@users.noreply.github.com>" [unknown]
>gpg:                 aka "Suheb <39208279+saubyk@users.noreply.github.com>" [unknown]
>gpg: WARNING: This key is not certified with a trusted signature!
>gpg:          There is no indication that the signature belongs to the owner.
>Primary key fingerprint: 3E9B D443 6C28 8039 CA82  7A92 00C9 E2BC 2E45 666F

56 - Descompactar o RTL:
```
 tar -xzf v0.14.1.tar.gz
```
57 - Ir para a pasta do aplicativo e instalar:
```
cd RTL-0.14.1
npm install --only-prod --legacy-peer-deps
```

58 - Copiar o arquivo exemplo da configuração:
```
cp Sample-RTL-Config.json RTL-Config.json
```

59 - Verificar o conteúdo
```
 nano RTL-Config.json
```
Inserir as informações abaixo, ajustando para sua configuração:
```
{
  "multiPass": "escolhaumasenhaforte",
  "port": "3000",
  "defaultNodeIndex": 1,
  "dbDirectoryPath": "/home/nauru/RTL",
  "SSO": {
    "rtlSSO": 0,
    "rtlCookiePath": "",
    "logoutRedirectLink": ""
  },
  "nodes": [
    {
      "index": 1,
      "lnNode": "T3R3N4ORG Node",
      "lnImplementation": "CLN",
      "Authentication": {
        "macaroonPath": "/home/nauru/c-lightning-REST-0.10.7/certs",
        "configPath": "/home/nauru/.lightning/config"
      },
      "Settings": {
        "userPersona": "OPERATOR",
        "themeMode": "NIGHT",
        "themeColor": "PURPLE",
        "channelBackupPath": "/home/nauru/.lightning/rtl-backup",
        "logLevel": "ERROR",
        "lnServerUrl": "https://127.0.0.1:3001",
        "fiatConversion": false,
        "unannouncedChannels": false
      }
    }
  ]
}
```

60 - Criar as pastas para backup do RTL
```
cd
cd .lightning/
mkdir rtl-backup
cd rtl-backup/
pwd
```

61 - Execute o programa do RTL
```
cd ~/RTL-0.14.1
node rtl
```
Haverá a saída abaixo:
> INFO: RTL => Server is up and running, please open the UI at http://localhost:3000 or your proxy configured url.

62 - Para verificar todos os serviços se estão rodando execute o comando:
```
lsof -i -P -n | grep LISTEN
```
A saída deverá ser: 
> bitcoind   2023 nauru   11u  IPv6  22335      0t0  TCP [::1]:8332 (LISTEN)
> bitcoind   2023 nauru   12u  IPv4  22337      0t0  TCP 127.0.0.1:8332 (LISTEN)
> bitcoind   2023 nauru   26u  IPv4  22340      0t0  TCP 127.0.0.1:8334 (LISTEN)
> bitcoind   2023 nauru   27u  IPv6  22341      0t0  TCP *:8333 (LISTEN)
> bitcoind   2023 nauru   28u  IPv4  22342      0t0  TCP *:8333 (LISTEN)
> lightning  4305 nauru    5u  IPv4  45563      0t0  TCP *:9735 (LISTEN)
> node      22244 nauru   28u  IPv6 171462      0t0  TCP *:3001 (LISTEN)
> node      22244 nauru   29u  IPv6 171463      0t0  TCP *:4001 (LISTEN)
> node      22900 nauru   25u  IPv6 173507      0t0  TCP *:3000 (LISTEN)

63 - Realize o acesso ao RTL localmente pela URL informada na saída ou então remotamente (pelo nome ou IP):
```
http://192.168.1.130:3000
```
## ATENÇÃO: Esse acesso não é criptografado, por isso   use apenas na sua rede local ou através de VPN TAILSCALE


## Backup dos Canais no CLN
Para manter um backup de segurança dos seus canais, um ponto de montagem diferente do seu disco normal pode ser usado. Por exemplo um pendrive de boa capacidade.
Os seguintes procedimentos devem ser realizados

64 - Monte o disco ou pendrive no seu node

65 - A seguinte linha deve ser adicionada no seu arquivo config alterando apropriadamente os seus apontamentos
```
# backup wallet=sqlite3:///home/nauru/.lightning/bitcoin/lightningd.sqlite3:/media/pen128gb/backup/lightningd.sqlite3 
```
66 - Realize o restart do node


## Como realizar o update do CLN

67 - Baixe a nova versão e realize os testes de integridade conforme mostrado na instalação inicial:
```
wget https://github.com/ElementsProject/lightning/releases/download/v23.11/clightning-v23.11-Ubuntu-22.04.tar.xz
```

68 - Parar o CLN

69 - Descompactar o pacote com o comando abaixo:
```
sudo tar -xvf <release>.tar.xz -C /usr/local --strip-components=2
```

70 - Na primeira vez que rodar use o comando abaixo para ser feito o update do Banco de Dados:
```
lightningd --database-upgrade=true
```


