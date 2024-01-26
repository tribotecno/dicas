# Passos para Instalação do NextCloud no Ubuntu 22.04

1 - Instalar os pacotes da requeridos (https://docs.nextcloud.com/server/latest/admin_manual/installation/example_ubuntu.html)
```
sudo apt update && sudo apt upgrade
```
```
sudo apt install apache2 mariadb-server libapache2-mod-php php-gd php-mysql \
php-curl php-mbstring php-intl php-gmp php-bcmath php-xml php-imagick php-zip
```
2 - Configurar o banco de dados
```
sudo mysql
```
3 - Criar o usuario e senha para acesso ao banco
```
CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';
CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON nextcloud.* TO 'username'@'localhost';
FLUSH PRIVILEGES;
```
4 - Sair da configuração do database
```
quit;
```
5 - Baixe o pacote de instalação do NextCloud (https://nextcloud.com/install/)
```
https://nextcloud.com/install
```
6 - Verifique o MD5 e SHA256 dos arquivos
```
md5sum -c nextcloud-x.y.z.tar.bz2.md5 < nextcloud-x.y.z.tar.bz2
sha256sum -c nextcloud-x.y.z.tar.bz2.sha256 < nextcloud-x.y.z.tar.bz2
md5sum  -c nextcloud-x.y.z.zip.md5 < nextcloud-x.y.z.zip
sha256sum  -c nextcloud-x.y.z.zip.sha256 < nextcloud-x.y.z.zip
```
7 - Verifique as assinaturas do PGP
```
wget https://download.nextcloud.com/server/releases/nextcloud-x.y.z.tar.bz2.asc
wget https://nextcloud.com/nextcloud.asc
gpg --import nextcloud.asc
gpg --verify nextcloud-x.y.z.tar.bz2.asc nextcloud-x.y.z.tar.bz2
```
8 - Desempacote o arquivo de acordo com o tipo baixado
```
tar -xjvf nextcloud-x.y.z.tar.bz2
unzip nextcloud-x.y.z.zip
```
9 - Copie a pasta para onde rodar o apache
```
sudo cp -r nextcloud /var/www
```
10 - Troque a propriedade para o usuario do apache
```
sudo chown -R www-data:www-data /var/www/nextcloud
```
11 - Configuração do Apache (https://docs.nextcloud.com/server/latest/admin_manual/installation/source_installation.html#apache-configuration-label)

12 - Configuração do PHP (https://docs.nextcloud.com/server/latest/admin_manual/installation/php_configuration.html)

13 - Edite o arquivo no nextcloud.conf e coloque as informações abaixo (pode alterar de acordo com a localização da pasta do NextCloud):
```
sudo nano /etc/apache2/sites-available/nextcloud.conf
```
```
Alias /nextcloud "/var/www/nextcloud/"
<Directory /var/www/nextcloud/>
  Require all granted
  AllowOverride All
  Options FollowSymLinks MultiViews
  <IfModule mod_dav.c>
    Dav off
  </IfModule>
</Directory>
```
Altere o nome do servidor para corresponder ao seu
```
<VirtualHost *:80>
  DocumentRoot /var/www/nextcloud/
  **ServerName  your.server.com**

  <Directory /var/www/nextcloud/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews

    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>
```
14 - Ative a configuração com o comando abaixo
```
sudo a2ensite nextcloud.conf
```
15 - Ative o modulo de rewrite
```
sudo a2enmod rewrite
```
16 - Os módulos abaixo também devem ser ativados
```
sudo a2enmod headers
sudo a2enmod env
sudo a2enmod dir
sudo a2enmod mime
```
17 - Restart o serviço do Apache
```
sudo systemctl restart apache2
```
18 - Continue a configuração pelo navegador acessando ao servidor diretament
```
http://nextcloud.tribotecno.org
```
19 - Caso deseje pode ativar o SSL com os comandos abaixo
```
sudo a2enmod ssl
sudo a2ensite default-ssl
sudo service apache2 reload
```
20 - Adicione as linhas abaixo no nextcloud.conf para escutar a porta ssl pelo nextcloud
```
sudo nano /etc/apache2/sites-available/nextcloud.conf
```
Altere o nome do servidor para corresponder ao seu
```
<VirtualHost *:443>
  DocumentRoot /var/www/nextcloud/
  **ServerName  your.server.com**

  <Directory /var/www/nextcloud/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews

    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>
```
Faça o teste usando o https
```
https://nextcloud.tribotecno.org
```
21 - O certificado SSL é auto assinado. Recomenda-se para internet usar a https://letsencrypt.org/ Faremos um tutorial sobre isso

