# 🚀 Instalação do Carbonio CE no Ubuntu 24.04

O **Carbonio CE** é uma suíte de colaboração e e-mail (derivada do Zimbra).  
Este guia mostra como instalar no **Ubuntu Server 24.04 LTS** com etapas detalhadas.  

---

## 📋 Requisitos

| Requisito        | Detalhe mínimo | Recomendado |
|------------------|----------------|-------------|
| 🖥️ Servidor       | 64 bits        | x86_64 com CPU moderna |
| 💾 Memória RAM    | 8 GB           | 16 GB+ |
| 💽 Disco         | 40 GB          | 100 GB+ (dependendo do volume de e-mails) |
| 🌐 Domínio       | DNS com A e MX | Certificados válidos SSL |
| 🔑 Acesso        | Root ou sudo   | Obrigatório |

---

## ✅ Checklist de preparação

- [x] Ubuntu Server 24.04 instalado  
- [x] Hostname configurado com **FQDN** (ex.: `mail.seudominio.com`)  
- [x] DNS apontando para o servidor (A e MX)  
- [x] Firewall ativo e pronto para configuração  

---

## ⚙️ Passo 1 — Preparar o servidor

```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Definir hostname (use seu FQDN)
sudo hostnamectl set-hostname carbonio.tutorial.tribotecno.org

# Ajustar arquivo hosts (substitua SEU_IP)
echo "SEU_IP carbonio.tutorial.tribotecno.org carbonio" | sudo tee -a /etc/hosts
````

---

## 📦 Passo 2 — Adicionar repositório do Carbonio CE

```bash
# Baixar script do repositório
wget https://repo.zextras.io/inst_repo_ubuntu.sh

# Executar script
sudo bash ./inst_repo_ubuntu.sh

# Atualizar pacotes
sudo apt update && sudo apt upgrade -y
```

---

## 🛠️ Passo 3 — Instalar o Carbonio CE

```bash
sudo apt install carbonio-ce -y
```

---

## 🔧 Passo 4 — Configuração inicial (Bootstrap)

✅ Importante:  Antes de rodar o comando abaixo seu DNS deve estar configurado com o registro MX, nome do servidor apontando para o IP e configuração do IP reverso apontando para o nome do servidor.

```bash
sudo carbonio-bootstrap
```
Informe as configurações de IP e senha do Mesh
```bash
sudo service-discover setup-wizard
```
Finalize as configurações pendentes
```bash
sudo pending-setups -a
```
Crie a conta do administrador com a senha desejada
```bash
sudo su - zextras
```
```bash
zmprov ca admin@tutorial.tribotecno.org minhasenhaforte10 zimbraIsAdminAccount TRUE
```
```bash
exit
```

👉 Durante o processo:

* Configure LDAP, MTA, Proxy, Mailbox
* Crie a conta **administrativa** (ex.: `admin@seudominio.com`)

---

## 🔥 Passo 5 — Ajustar firewall

```bash
sudo ufw allow 25/tcp    # SMTP
sudo ufw allow 465/tcp   # SMTPS
sudo ufw allow 587/tcp   # Submission
sudo ufw allow 110/tcp   # POP3
sudo ufw allow 995/tcp   # POP3S
sudo ufw allow 143/tcp   # IMAP
sudo ufw allow 993/tcp   # IMAPS
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
# Recomendamos que a porta 6071 seja aberta apenas para a VPN
sudo ufw allow 6071/tcp  # Admin Console
```

---

## 🔒 Passo 6 — Configurar SSL com Let's Encrypt
Na interface gráfica do Navegador na parte de administração 
Ir para virtual host e certificados
Criar o alias para o virtualhost (pode ser o mesmo nome)
Dar um reboot no servidor
Retornar da interface grafica
Clicar em verificar certificado
Na próxima janela clicar em GERAR CERTIFICADO
Confira se o certificado foi gerado corretamenta verificando a mensagem enviada para o usuário zextras
Dar novamente o reboot no servidor
Fechar os navegadores para limpar o cache
Acessar novamente e verificar se o certificado foi carregado corretamente.



```bash
# Instalar certbot
sudo apt install certbot -y

# Gerar certificado
sudo certbot certonly --standalone -d mail.seudominio.com
```

👉 Copie e aplique os certificados no Carbonio:

```bash
sudo zmcertmgr verifycrt comm \
  /etc/letsencrypt/live/mail.seudominio.com/privkey.pem \
  /etc/letsencrypt/live/mail.seudominio.com/fullchain.pem

sudo zmcertmgr deploycrt comm \
  /etc/letsencrypt/live/mail.seudominio.com/cert.pem \
  /etc/letsencrypt/live/mail.seudominio.com/chain.pem
```

---

## 🌍 Passo 7 — Acessar interfaces web

| Interface        | URL de acesso                                                        |
| ---------------- | -------------------------------------------------------------------- |
| 📧 Webmail       | [https://mail.seudominio.com](https://mail.seudominio.com)           |
| ⚙️ Admin Console | [https://mail.seudominio.com:6071](https://mail.seudominio.com:6071) |

---
## 🌍 Passo 8 — Configure o SPF - DKIM - DMARC
Insira no seu DNS as entradas TXT para:

SPF
v=spf1 mx include:carbonio.tutorial.tribotecno.org -all

DKIM
Gere o DKIM para o seu dominio no carbonio:
zmdkimkeyutil -a -d tutorial.tribotecno.org

 /opt/zextras/libexec/zmdkimkeyutil -a -d tutorial.tribotecno.org
DKIM Data added to LDAP for domain tutorial.tribotecno.org with selector A175636E-A53E-11F0-B115-6CD0D3453A97
Public signature to enter into DNS:
A175636E-A53E-11F0-B115-6CD0D3453A97._domainkey IN      TXT     ( "v=DKIM1; k=rsa; "
          "p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA9IhCO7k8Hj0Ima5ponYCwLSH/eyALa9RngMtUkH8RFZmcnr1BqQ/g2IHjT7VEKvB8tdw2YfnRKEf5jxlxhsuYtqw5CxtbZ9vxnOI8TaBkI0Exv8UaalU7JgokhJbbGW9jaOMJm6diYREYahEZWEhI1AppNe11ny3Q7lpXZ1/CIFeziM5nPYApXLNN5eZ4w/qxgWN1GjHZdvMTI"
          "RZRncOKaEq8HS8h0V0uWFwWdCevLd/6OoWysZnPaYMFJYXAOn8VeVHvgCqgFQMjLF9lAZNeVYPGtjYSofnFJ1uw4PMqnbG89Ns7oIrNYZoZTCbOktfF1v3Qj3y+YJ6YR4DzbJUQwIDAQAB" )  ; ----- DKIM key A175636E-A53E-11F0-B115-6CD0D3453A97 for tutorial.tribotecno.org

Depois de carregar no seu DNS faça o teste com comando abaixo de outro máquina:
nslookup -type=txt a175636e-a53e-11f0-b115-6cd0d3453a97._domainkey.tutorial.tribotecno.org

Veifique se o DKIM está habilitado no carbonio
sudo su - zextras
carbonio prov gs $(zmhostname)|grep -i opendkim

Criar o registro DMARC no DNS
Name: _dmarc.tutorial.tribotecno.org
Type: TXT
Value: "v=DMARC1; p=none; rua=mailto:dmarc@tutorial.tribotecno.org; pct=100; sp=none"

Atenção:
p=none → apenas monitoramento (recomendado nas primeiras semanas).
Depois de validar relatórios, evolua para p=quarantine e, quando seguro, para p=reject.
rua é o endereço para receber relatórios agregados (XML). Crie essa mailbox antes de apontar para ela.





## 🎉 Conclusão

Seu servidor **Carbonio CE** está instalado e funcionando no **Ubuntu 24.04** 🚀
Agora é só gerenciar usuários, domínios e começar a usar o webmail.

---

📌 **Referência oficial:** [Zextras Carbonio CE Documentation](https://docs.zextras.com/carbonio-ce/html/install/scenarios/single-server-scenario.html)

