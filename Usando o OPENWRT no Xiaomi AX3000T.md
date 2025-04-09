# Usando o OpenWRT para substituir o firmware no roteador Wifi Xiaomi AX3000T #

Recomendamos executar esse tutorial com o vídeo do youtube https://youtu.be/aindavoucolocar

1 - Verifique se o seu roteador Ax3000T atende os requisitos conforme o link https://openwrt.org/inbox/toh/xiaomi/ax3000t#hardware_support_status ou no seletor de firmware em https://toh.openwrt.org/?view=normal

2 - Mais informações podem ser obtidas na discussão do forum do OpenWRT neste link https://forum.openwrt.org/t/openwrt-support-for-xiaomi-ax3000t/180490

3 - ATENÇÃO: PODER SER QUE O SEU ROTEADOR FIQUE BRICKED (INUTILIZADO) COMO OS PROCEDIMENTOS NESTE TUTORIAL. POR ISSO FAÇA POR SUA CONTA E RISCO!!!

4 - Faça o reset para as configurações de fábrica conforme demonstrado no vídeo

5 - Instale a versão do python no seu computador. No caso estamos usando o Windows 11 e instalaremos a versão 3.11 diretamente da loja da Microsoft

6 - Abra um powershel como administrador e ative o ambiente do python 
```
python -m venv venv
```
```
Set-ExecutionPolicy RemoteSigned
```
```
.\venv\Scripts\Activate.ps1
```

7 - Faça a clonagem do xamir-patcher
```
cd \
git clone --recursive https://github.com/openwrt-xiaomi/xmir-patcher
```
8 - Realize o download da imagem para a pasta firmware do xmir-patcher
```
https://downloads.openwrt.org/releases/24.10.0/targets/mediatek/filogic/openwrt-24.10.0-mediatek-filogic-xiaomi_mi-router-ax3000t-initramfs-factory.ubi
```
9 - Siga sequencia do menu do xmir-patcher
