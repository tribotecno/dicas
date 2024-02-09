# Instalando o MacOS no KVM

Essa instalação irá seguir os passos do https://github.com/kholia/OSX-KVM

Utilize o video http://youtube.com para acompanhar a instalação

O hospedeiro utilizado possui a seguinte configuração:
- CPU Intel I7-4790K @ 4.00GHz
- Memoria 32Gb
- Sistema Operacional Ubuntu 22.04.3 LTS
- Resolução do Display 1920x1080 pixels


1 - Requerimentos
Uma distribuição moderma do Linux: Ubuntu 22.04 LTS 64-bit ou posterior.
QEMU >= 6.2.0
Uma CPU com suporte Intel VT-x / AMD SVM é requerida. Teste seu hospedeiro com o comando abaixo:
```
grep -e vmx -e svm /proc/cpuinfo
```
Uma CPU com suporte SSE4.1 se for usar >= macOS Sierra

Uma CPU com suporte AVX2 se for usar   >= macOS Mojave

No vídeo usamos o aplicativo hardinfo:
```
sudo apt install hardinfo
```
```
hardinfo
```

2 - Instalar os pacotes necessários
```
sudo apt-get install qemu uml-utilities virt-manager git \
    wget libguestfs-tools p7zip-full make dmg2img tesseract-ocr \
    tesseract-ocr-eng genisoimage -y
```	
3 - Clonar o repositorio
```
cd ~
git clone --depth 1 --recursive https://github.com/kholia/OSX-KVM.git
cd OSX-KVM
```
4 - Fazer o update se for o caso
```
git pull --rebase
```
5 - Alteração na conf do kvm. Use o comando apropriado se sua CPU for Intel ou AMD
```
sudo cp kvm.conf /etc/modprobe.d/kvm.conf  # for intel boxes only
sudo cp kvm_amd.conf /etc/modprobe.d/kvm.conf  # for amd boxes only
```
Adicionar o seu usuários aos grupos do KVM:
```
sudo usermod -aG kvm $(whoami)
sudo usermod -aG libvirt $(whoami)
sudo usermod -aG input $(whoami)
```
Após essa cópia realize um reboot no hospedeiro e retorne a pasta para continuar a instalação:
```
sudo reboot
```
Após o retorno do hospedeiro:
```
cd OSX-KVM
```
6 - Buscar o Instalador do MacOS
```
./fetch-macOS-v2.py
```
Ele irá dar as opções abaixo. Sugerimos o Ventura como recomendado:
```
$ ./fetch-macOS-v2.py
1. High Sierra (10.13)
2. Mojave (10.14)
3. Catalina (10.15)
4. Big Sur (11.7)
5. Monterey (12.6)
6. Ventura (13) - RECOMMENDED
7. Sonoma (14)

Choose a product to download (1-6): 6
```
Converter o arquivo baixado BaseSystem.dmg para BaseSystem.img:
```
dmg2img -i BaseSystem.dmg BaseSystem.img
```
7 - Editar o arquivo OpenCore para a config desejada. Verifique no vídeo para mais detalhes.
```
cp OpenCore-Boot.sh OpenCore-Boot.sh.orig
```
```
nano OpenCore-Boot.sh
```
**Observe os comentários no vídeo sobre as principais alterações no arquivo, porém ele é auto-explicativo para outras mudanças**
  
8 - Criar o disco onde será instalado o MacOS
```
qemu-img create -f qcow2 mac_hdd_ng.img 128G
```
9 - Começar a instalação executando o comando abaixo:
```
./OpenCore-Boot.sh
```
10 - Para utilizar o virt-manager gere um no xml conforme mostrado abaixo:
```
sed "s/CHANGEME/$USER/g" macOS-libvirt-Catalina.xml > macOS.xml
virt-xml-validate macOS.xml
virsh --connect qemu:///system define macOS.xml
```
11 - Atribuia os direitos de acesso ao qemu
```
sudo setfacl -m u:libvirt-qemu:rx /home/$USER
sudo setfacl -R -m u:libvirt-qemu:rx /home/$USER/OSX-KVM
```
12 - Caso tenha problemas em instalar os aplicativos da loja da apple, ajustar a parte da rede para ser en0 na VM para isso:
12.1 - Delete toda a configuração na configuração de sistemas na parte de redes
12.2 - Abra um terminal no MacOS e remova o arquivo de interfaces com o comando:
```
sudo rm /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist
```
12.3 - Realize o reboot e com o comando abaixo no terminal verifique se a interface foi corrigida:
```
ifconfig -a # deve aparecer en0 com o endereço IP correto
```
13 - Com o virt-manager no primeiro boot deve ser modificado o volume do boot como explicado no video
