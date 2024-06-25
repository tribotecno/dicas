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
Caso apareça a mensagem de erro: AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message corrija seu arquivo /etc/hosts como mostrado no vídeo.

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

23 - Testando o processamento do PHP no Servidor Web
```
nano /var/www/your_domain/info.php
```
Coloque o conteúdo abaixo no arquivo
```
<?php
phpinfo();
```

24 - Teste para ver se está funcionando
```
http://server_domain_or_IP/info.php
```

25 - Não é bom deixar esse arquivo na pasta. Remova para mais segurança
```
sudo rm /var/www/your_domain/info.php
```

26 - Testando a Conexão do MySQL com o PHP
```
sudo mysql -p
```

27 - Crie um database de teste
```
CREATE DATABASE example_database;
```

28 - Crie o usuário para acessar ao database
```
CREATE USER 'example_user'@'%' IDENTIFIED BY 'password';
```

29 - Conceda o privilégio de acesso
```
GRANT ALL ON example_database.* TO 'example_user'@'%';
```

Saia da conexão com
```
exit
```

30 - Vamos testar o acesso do usuário
```
mysql -u example_user -p
```

31 - Verifique se mostra o database
```
SHOW DATABASES;
```

32 - Vamos criar uma tabela todo_list
```
CREATE TABLE example_database.todo_list (
  item_id INT AUTO_INCREMENT,
  content VARCHAR(255),
  PRIMARY KEY(item_id)
);
```

33 - Vamos inserir alguns dados
```
INSERT INTO example_database.todo_list (content) VALUES ("My first important item");
```
Repita o comando acima variando o valor para ter mais dados de teste

34 - Vamos verificar se os dados foram inseridos
```
SELECT * FROM example_database.todo_list;
```

35 - Após confirmado saida do banco
```
exit
```

36 - Vamos criar um acesso para listar os dados pelo PHP 
```
nano /var/www/your_domain/todo_list.php
```
Insira o código abaixo
```
<?php
$user = "example_user";
$password = "password";
$database = "example_database";
$table = "todo_list";

try {
  $db = new PDO("mysql:host=localhost;dbname=$database", $user, $password);
  echo "<h2>TODO</h2><ol>";
  foreach($db->query("SELECT content FROM $table") as $row) {
    echo "<li>" . $row['content'] . "</li>";
  }
  echo "</ol>";
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}
```
CRTL-X para salvar o arquivo

37 - Vamos verificar se o código está funcionando
```
http://your_domain_or_IP/todo_list.php
```

38 - Vc pode habilitar o acesso ao seu servidor externamente assistindo esses videos do nosso canal

https://youtu.be/joFMPgLL1iY - Configurando o Modem Router para redirecionar portas

https://youtu.be/iTLnP9QjTQA - Usando um DNS dinamico para o seu site



