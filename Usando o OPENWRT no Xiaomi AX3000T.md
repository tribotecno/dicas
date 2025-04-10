# Usando o OpenWRT para substituir o firmware no roteador Wifi Xiaomi AX3000T #

Recomendamos executar esse tutorial com o vídeo do youtube https://youtu.be/cFXNTJsiAs0

1 - Verifique se o seu roteador Ax3000T atende os requisitos conforme o link https://openwrt.org/inbox/toh/xiaomi/ax3000t#hardware_support_status ou no seletor de firmware em https://toh.openwrt.org/?view=normal

2 - Mais informações podem ser obtidas na discussão do forum do OpenWRT neste link https://forum.openwrt.org/t/openwrt-support-for-xiaomi-ax3000t/180490

3 - ATENÇÃO: PODE SER QUE O SEU ROTEADOR FIQUE BRICKED (INUTILIZADO) COMO OS PROCEDIMENTOS NESTE TUTORIAL. POR ISSO FAÇA POR SUA CONTA E RISCO!!!

4 - Faça o reset para as configurações de fábrica conforme demonstrado no vídeo

5 - Instale a versão do python no seu computador. No caso estamos usando o Windows 11 e instalaremos a versão 3.11 diretamente da loja da Microsoft

6 - Instale uma versão do GIT para baixar o repositório do xmir-patcher
```
https://git-scm.com/downloads/win
```
7 - Abra um powershel como administrador e ative o ambiente do python 
```
cd \
python -m venv venv
```
```
Set-ExecutionPolicy RemoteSigned
```
```
.\venv\Scripts\Activate.ps1
```

8 - Faça a clonagem do xamir-patcher
```
git clone --recursive https://github.com/openwrt-xiaomi/xmir-patcher
```
9 - Realize o download da imagem para a pasta firmware do xmir-patcher
```
https://downloads.openwrt.org/releases/24.10.0/targets/mediatek/filogic/openwrt-24.10.0-mediatek-filogic-xiaomi_mi-router-ax3000t-initramfs-factory.ubi
```
10 - Siga sequencia do menu do xmir-patcher após rodar o run.bat (no caso rodando no Windows)
```
cd xmir-patcher
run.bat
```
11 - Após a instalação do firmware do Openwrt realize os seguintes passos:

Passo 1 - Desligue o equipamento;

Passo 2 - Retire o cabo de rede da porta WAN (porta ao lado do conector da fonte) e coloque em uma das 3 portas seguintes (estas seriam as portas da LAN);

Passo 3 - Acesse pelo browser o endereço 192.168.1.1 ;

Passo 4 - Baixe a versão de Upgrade e realize o upload de atualização;
```
https://downloads.openwrt.org/releases/24.10.0/targets/mediatek/filogic/openwrt-24.10.0-mediatek-filogic-xiaomi_mi-router-ax3000t-squashfs-sysupgrade.bin
```
Passo 5 - Um reboot vai ser realizado e o equipamento irá estar pronto para inicio da configuração.




