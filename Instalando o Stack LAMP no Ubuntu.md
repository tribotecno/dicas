# Como instalar o Linux, Apache, MySQL e PHP (LAMP) no Ubuntu

0 - Neste tutorial partimos do pressuposto do servidor Ubuntu já estar instalado. Para aprender assistam alguns desses nossos videos no canal:

https://youtu.be/ifIrWBHU8gs

https://youtu.be/zFXTC8Qimf8

https://youtu.be/jVxk6pVgiuI

1 - Instalar os pacotes básicos necessários
```
sudo apt-get install -y software-properties-common
```

2 - Instalar o Apache
```
sudo apt install apache2
```

3 - Verificar se o serviço do Apache levantou
```
http://your_server_ip
```

4 - Para saber todos os IPs que o seu servidor está configurado
```
ip a|grep inet
```

5 - Instalando o MySQL
```
sudo apt install mysql-server
```

6 - Configurando a senha do admin do Banco de Dados
```
sudo mysql
```

7 - Alterando a senha do admin
```
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
```

8 - Para sair do MySQL
```
exit
```

9 - Instalando os pacotes do PHP
```
sudo apt install php libapache2-mod-php php-mysql
```

10 - Testando a instalação do PHP
```
php -v
```

11  Trocando o Indice de Diretórios do Apache
```
sudo nano /etc/apache2/mods-enabled/dir.conf
```

12 - Insira a informação abaixo
```
<IfModule mod_dir.c>
    DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm
</IfModule>
```

13 - Pressione CTRL+X para gravar o arquivo. Reinicie o Apache para aplicar a configuração
```
sudo systemctl restart apache2
```

14 - Para verificar se o Apache está rodando corretamente use o comando abaixo
```
sudo systemctl status apache2
```

15 - Criando o Virtual Host para seu WebSite
```
sudo mkdir /var/www/your_domain
```
Habilite seu usuário a poder escrever na pasta
```
sudo chown -R $USER:$USER /var/www/your_domain
```

16 - Colocando o Website disponível ao Apache
```
sudo nano /etc/apache2/sites-available/your_domain.conf
```
Insira as informações abaixo, fazendo as modificações necessárias ao seu site
```
<VirtualHost *:80>
    ServerName your_domain
    ServerAlias www.your_domain
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/your_domain
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

17 - Habilite o seu site com o comando abaixo, modificando o comando para a sua configuração
```
sudo a2ensite your_domain
```

18 - Verifique se suas configurações estão corretas
```
sudo apache2ctl configtest
```

19 - Aplique as configurações no Apache
```
sudo systemctl reload apache2
```

20 - O Website está ativado e rodando. Crie uma página de teste
```
nano /var/www/your_domain/index.html
```

21 - Insira o exemplo
```
<html>
  <head>
    <title>your_domain website</title>
  </head>
  <body>
    <h1>Hello World!</h1>

    <p>This is the landing page of <strong>your_domain</strong>.</p>
  </body>
</html>
```

22 - Faça o teste acessando a página
```
http://server_domain_or_IP
```


```
```

```
```




