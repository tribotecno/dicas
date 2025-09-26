# 📘 Guia de Instalação do MediaWiki 1.40.0 no Ubuntu

## 🔧 Pré-requisitos

* Servidor rodando **Ubuntu 20.04/22.04/24.04**
* Usuário com privilégios **sudo**
* Acesso à internet

---

## 1️⃣ Atualizar pacotes do sistema

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 2️⃣ Instalar dependências

Instale Apache, MariaDB/MySQL, PHP e extensões necessárias:

```bash
sudo apt install apache2 mariadb-server php libapache2-mod-php php-mysql \
php-intl php-xml php-mbstring php-apcu php-gd php-curl unzip wget -y
```

Ativar módulos do Apache:

```bash
sudo a2enmod rewrite
sudo systemctl restart apache2
```

---

## 3️⃣ Instalar o MariaDB

```bash
sudo apt install mariadb-server mariadb-client -y
sudo mysql_secure_installation
```

---
##  Criar banco de dados

Entre no MariaDB/MySQL:

```bash
sudo mysql -u root -p
```

No console SQL, execute:

```sql
CREATE DATABASE wikidb;
CREATE USER 'wikiuser'@'localhost' IDENTIFIED BY 'senha_forte';
GRANT ALL PRIVILEGES ON wikidb.* TO 'wikiuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

---

## 4️⃣ Baixar o MediaWiki 1.40.0

```bash
cd /tmp
wget https://releases.wikimedia.org/mediawiki/1.40/mediawiki-1.40.0.tar.gz
tar -xvzf mediawiki-1.40.0.tar.gz
sudo mv mediawiki-1.40.0 /var/www/html/mediawiki
```

---

## 5️⃣ Ajustar permissões

```bash
sudo chown -R www-data:www-data /var/www/html/mediawiki
sudo chmod -R 755 /var/www/html/mediawiki
```

---

## 6️⃣ Configurar Apache

Crie o arquivo de configuração:

```bash
sudo nano /etc/apache2/sites-available/mediawiki.conf
```

Adicione:

```apache
<VirtualHost *:80>
    ServerName sua-wiki.com
    DocumentRoot /var/www/html/mediawiki

    <Directory /var/www/html/mediawiki/>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/mediawiki_error.log
    CustomLog ${APACHE_LOG_DIR}/mediawiki_access.log combined
</VirtualHost>
```

Ative o site e recarregue:

```bash
sudo a2ensite mediawiki.conf
sudo systemctl reload apache2
```

---

## 7️⃣ Instalação via navegador

Abra no navegador:

```
http://SEU_IP/mediawiki
```

ou

```
http://sua-wiki.com
```

* Configure idioma, banco de dados e usuário admin.
* No final, será gerado o arquivo **LocalSettings.php**.

Mova o arquivo para:

```bash
/var/www/html/mediawiki/LocalSettings.php
```

---

## 8️⃣ (Opcional) Ativar HTTPS

Se possuir domínio configurado:

```bash
sudo apt install certbot python3-certbot-apache -y
sudo certbot --apache -d sua-wiki.com
```

---

## ✅ Conclusão

Seu **MediaWiki 1.40.0 (LTS)** está instalado e pronto para uso! 🎉
Agora você pode instalar **extensões e skins** para personalizar sua wiki.

---

👉 Quer que eu já gere esse guia como um **arquivo `.md` pronto para download** para você subir direto no GitHub?
