# 📘 Instalação do DokuWiki no Ubuntu Server

Este guia mostra como instalar e configurar o **DokuWiki** em um **Ubuntu Server**, incluindo:
- Servidor Apache e PHP  
- Configuração de VirtualHost  
- Firewall (UFW)  
- Certificado SSL gratuito com **Let's Encrypt (Certbot)**  

---

## 🚀 Passo 1 – Atualizar o sistema
```bash
sudo apt update && sudo apt upgrade -y
````

---

## 📦 Passo 2 – Instalar Apache, PHP e dependências

```bash
sudo apt install apache2 php libapache2-mod-php php-xml php-gd unzip wget -y
```

---

## 📥 Passo 3 – Baixar a última versão do DokuWiki

```bash
cd /tmp
wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
tar -xvzf dokuwiki-stable.tgz
```

---

## 📂 Passo 4 – Mover para o diretório do Apache

```bash
sudo mv dokuwiki /var/www/html/dokuwiki
```

---

## 🔑 Passo 5 – Ajustar permissões

```bash
sudo chown -R www-data:www-data /var/www/html/dokuwiki
sudo chmod -R 755 /var/www/html/dokuwiki
```

---

## ⚙️ Passo 6 – Criar configuração no Apache

Crie o arquivo de configuração:

```bash
sudo nano /etc/apache2/sites-available/dokuwiki.conf
```

Adicione o conteúdo abaixo (substitua `wiki.seudominio.com` pelo seu domínio):

```apache
<VirtualHost *:80>
    ServerAdmin admin@seudominio.com
    DocumentRoot /var/www/html/dokuwiki
    ServerName wiki.seudominio.com

    <Directory /var/www/html/dokuwiki>
        Options +FollowSymlinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/dokuwiki_error.log
    CustomLog ${APACHE_LOG_DIR}/dokuwiki_access.log combined
</VirtualHost>
```

---

## ▶️ Passo 7 – Ativar site e módulos necessários

```bash
sudo a2ensite dokuwiki.conf
sudo a2enmod rewrite
sudo systemctl reload apache2
```

---

## 🔥 Passo 8 – Configurar o firewall (UFW)

Ative o firewall e libere **HTTP + HTTPS**:

```bash
sudo ufw allow "Apache Full"
sudo ufw enable
sudo ufw status
```

---

## 🔒 Passo 9 – Instalar Certbot e habilitar SSL (HTTPS)

Instale o **Certbot** e o plugin do Apache:

```bash
sudo apt install certbot python3-certbot-apache -y
```

Obtenha o certificado SSL (substitua pelo seu domínio real):

```bash
sudo certbot --apache -d wiki.seudominio.com
```

* Escolha a opção para **redirecionar HTTP → HTTPS**.

Teste a renovação automática:

```bash
sudo certbot renew --dry-run
```

---

## 🌐 Passo 10 – Acessar via navegador

Abra no navegador:

```
https://wiki.seudominio.com/install.php
```

Configure:

* Nome do Wiki
* Usuário administrador
* Senha de administrador

---

## 🛡️ Passo 11 – Remover instalador por segurança

```bash
sudo rm /var/www/html/dokuwiki/install.php
```

---

## ✅ Conclusão

Agora seu **DokuWiki** está instalado no **Ubuntu Server**, protegido por **UFW** e com **SSL gratuito (Let's Encrypt)**.

Você já pode começar a criar suas páginas e configurar seu Wiki! 🚀


