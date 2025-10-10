# 🌐 Instalação do Webmin no Ubuntu

O **Webmin** é um painel de administração baseado na web que facilita a configuração de servidores Linux, incluindo:

🔹 Gerenciamento de usuários  
🔹 Configuração de Apache/Nginx  
🔹 Controle de firewall (iptables/ufw)  
🔹 DNS, DHCP e compartilhamentos  
🔹 Monitoramento do sistema  

Com ele, você pode gerenciar o servidor direto do navegador, de forma simples e prática.  

O vídeo com a demonstração de passo a passo pode ser acessado aqui: https://youtu.be/aw2YOgZ92eM

---

## ⚡ Pré-requisitos
- Ubuntu atualizado (20.04, 22.04 ou superior)  
- Acesso root ou usuário com **sudo**  
- Conexão com a internet  

---

## 🛠️ Passo 1 – Atualizar o sistema
```bash
sudo apt update && sudo apt upgrade -y
````

---

## 📦 Passo 2 – Instalar dependências necessárias

```bash
sudo apt install -y software-properties-common apt-transport-https wget
```

---

## 📥 Passo 3 – Adicionar o repositório oficial do Webmin

```bash
curl -o webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh
sudo sh webmin-setup-repo.sh
```

---

## ⚙️ Passo 4 – Instalar o Webmin

```bash
sudo apt update
sudo apt install -y webmin
```

---

## 🌍 Passo 5 – Acessar o Webmin

Por padrão, o Webmin roda na porta **10000**.

Abra o navegador e acesse:

```
https://SEU_IP:10000
```

Exemplo:

```
https://192.168.1.10:10000
```

⚠️ Será necessário aceitar o certificado SSL autoassinado.

---

## 🔑 Passo 6 – Login

Entre com o usuário **root** ou qualquer outro que possua privilégios **sudo**.

---

## 🔓 (Opcional) Liberar firewall (UFW), caso não esteja usando VPN

Se o firewall UFW estiver ativo, libere a porta:

```bash
sudo ufw allow 10000/tcp
sudo ufw reload
```

---

## 🎉 Conclusão

Pronto! Agora o **Webmin** está instalado e você pode administrar seu servidor Ubuntu diretamente pelo navegador, com interface gráfica e ferramentas poderosas.

---

### 📚 Documentação oficial

👉 [https://www.webmin.com/](https://www.webmin.com/)
