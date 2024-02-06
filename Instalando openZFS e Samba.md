# Passos para a montagem do armazenamento caseiro #

0 - Recomendamos que use esse tutorial juntamente com o vídeo  https://youtu.be/kOqfm-3t1S8 

1 - Instalar o openZFS
```
sudo apt update && sudo apt install zfsutils-linux -y
```
2 - Verificando os discos instalado no seu servidor
```
sudo lsblk -a
```
3 - Limpando as informações de partição dos discos
```
sudo wipefs -a /dev/sda # Para cada disco repita o comando variando a letra sda sdb etc
```
4 - Listando as ids dos discos a serem utilizados
```
ls -la /dev/disk/by-id/ |grep ata
```
5 - Comando para montar o volume ZFS. Modifique ao que representa sua configuração
```
zpool create -O mountpoint=/mnt/datavol datavol raidz2 ata-Fanxiang_S101_2TB_MX_00000000000010082 ata-Fanxiang_S101_2TB_MX_00000000000030082 ata-Netac_SSD_2TB_AA202211172TB6843669 ata-Netac_SSD_2TB_AA202310132T02111230 ata-SSD_2TB_AA000000000000000794 -f
```
6 - Instalar o aplicativo SAMBA
```
sudo apt update && sudo apt install samba -y
```
7 - Comandos para criar a pasta compartilhada. Modifique ao seu gosto
```
sudo mkdir /mnt/datavol/pastanauru
sudo chown nauru:nauru /mnt/datavol/pastanauru
sudo smbpasswd -a nauru
```
8 - Edite o arquivo do samba
```
sudo nano /etc/samba/smb.conf
```
9 - Insira ao final do arquivo a montagem do compartilhamento da pasta
```
[pastanauru]
   path = /mnt/datavol/pastanauru
   available = yes
   valide users = nauru
   read only = no
   writeable = yes
   browseable = yes
   public = yes
```
10 - Reinicie o serviço do samba
```
sudo systemctl restart samba
```
11 - Acesso pelo Windows verifique no video da dica

