# Passos para instalação

1 - Testar se o suporte da virtualização está ativado
```
grep -e vmx -e svm /proc/cpuinfo
```
2 - Instalar os pacotes do KVM
```
sudo apt install -y qemu-kvm virt-manager libvirt-daemon-system virtinst libvirt-clients bridge-utils
```
3 - Colocar usuario nos grupos do KVM
```
sudo usermod -aG kvm $(whoami)
sudo usermod -aG libvirt $(whoami)
sudo usermod -aG input $(whoami)
```
4 - Colocar as informações da bridge-utils
```
sudo nano /etc/netplan/00-installer-config.yaml
```
Compare esse exemplo da nossa máquina e modifique para sua configuração. Cuidado com a identação
```
# This is the network config written by 'subiquity'
network:
  bonds:
    bond0:
      addresses:
      - 192.168.1.30/24
      interfaces:
      - enp6s0f0
      - enp3s0
      nameservers:
        addresses:
        - 1.1.1.1
        - 8.8.8.8
        search:
        - tribotecno.org
      parameters:
        mode: active-backup
      routes:
      - to: default
        via: 192.168.1.254
  bridges:
    br0:
      interfaces:
        - enp6s0f1
  ethernets:
    enp6s0f0: {}
    enp6s0f1: {}
    enp3s0: {}
  version: 2
```
5 - Baixar os aplicativos de driver
```
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.240-1/virtio-win-0.1.240.iso
```
6 - Comandos úteis:
6.1 - Listar as máquinas virtuais que estão rodando no hospedeiro
```
virsh list
```
6.2 - Iniciar uma VM
```
virsh start nomedamaquina
```
6.3 - Desligar uma VM
```
virsh shutdown nomedamaquina
```
7 - Alterar o arquivo de configuração da VM para aparecer a quantidade correta de processadores
 Editar o arquivo:
```
 sudo nano /etc/libvirt/qemu/nomedamaquina.xml
```
 Na parte da cpu deve ficar dessa forma alterando apenas o campo cores como explicado no vídeo:
```
   <cpu mode='host-passthrough' check='none' migratable='on'>
    <topology sockets='1' dies='1' cores='2' threads='2'/>
  </cpu>
  ```
  Se definiu por exemplo com 16 processadores altere em cores='' colocando a metade do valor, no caso 8.
  
  Releia o arquivo de configuração com o comando:
  ```
  sudo virsh define /etc/libvirt/qemu/nomedamaquina.xml
  ```

  
