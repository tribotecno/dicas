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
sudo ufw allow 6071/tcp  # Admin Console
```

---

## 🔒 Passo 6 — Configurar SSL com Let's Encrypt

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

## 🎉 Conclusão

Seu servidor **Carbonio CE** está instalado e funcionando no **Ubuntu 24.04** 🚀
Agora é só gerenciar usuários, domínios e começar a usar o webmail.

---

📌 **Referência oficial:** [Zextras Carbonio CE Documentation](https://docs.zextras.com/carbonio-ce/html/install/scenarios/single-server-scenario.html)

