````markdown
# 📘 Instalação do WordPress no Ubuntu Server

Este guia mostra como instalar e configurar o **WordPress** em um servidor **Ubuntu (22.04/24.04)** utilizando **Apache, PHP e MariaDB**.  

---

## 🔹 1. Atualizar o sistema
```bash
sudo apt update && sudo apt upgrade -y
````

---

## 🔹 2. Instalar o Apache

```bash
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2
```

Teste no navegador:

```
http://IP_DO_SERVIDOR
```

---

## 🔹 3. Instalar PHP e extensões

```bash
sudo apt install php php-mysql php-xml php-curl php-gd php-mbstring libapache2-mod-php -y
```

---

## 🔹 4. Instalar o MariaDB

```bash
sudo apt install mariadb-server mariadb-client -y
sudo mysql_secure_installation
```

---

## 🔹 5. Criar o banco de dados do WordPress

```bash
sudo mysql -u root -p
```

Dentro do MySQL/MariaDB:

```sql
CREATE DATABASE wordpress;
CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'SENHA_FORTE';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

---

## 🔹 6. Baixar e configurar o WordPress

```bash
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
sudo mv wordpress /var/www/html/
```

---

## 🔹 7. Ajustar permissões

```bash
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress
```

---

## 🔹 8. Configurar o Apache

Crie o arquivo:

```bash
sudo nano /etc/apache2/sites-available/wordpress.conf
```

Conteúdo:

```apache
<VirtualHost *:80>
    ServerAdmin admin@dominio.com
    DocumentRoot /var/www/html/wordpress
    ServerName dominio.com
    ServerAlias www.dominio.com

    <Directory /var/www/html/wordpress/>
        AllowOverride All
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/wordpress_error.log
    CustomLog ${APACHE_LOG_DIR}/wordpress_access.log combined
</VirtualHost>
```

Ativar o site:

```bash
sudo a2ensite wordpress.conf
sudo a2enmod rewrite
sudo systemctl reload apache2
```

---

## 🔹 9. Instalar o WordPress via navegador

Acesse no browser:

```
http://IP_DO_SERVIDOR
```

ou

```
http://dominio.com
```

Preencha:

* Banco de dados: `wordpress`
* Usuário: `wpuser`
* Senha: `SENHA_FORTE`
* Servidor: `localhost`

---

## 🔹 10. (Opcional) Habilitar HTTPS com Let’s Encrypt

Se já possuir um domínio:

```bash
sudo apt install certbot python3-certbot-apache -y
sudo certbot --apache -d dominio.com -d www.dominio.com
```

---

## ✅ Conclusão

Pronto! Agora você tem o **WordPress rodando no Ubuntu** 🎉

```

---

Quer que eu já monte também um **`install_wordpress.sh`** para incluir no mesmo repositório e automatizar a instalação?
```
