# Instalando a Carteira Jade no dispositivo T-DISPLAY S3 PRO #
Recomendamos usar esse tutorial com o vídeo do youtube https://youtu.be/BpVk2lKNK_c

Para adquirir a T-DISPLAY S3 PRO utilize o nosso link:

https://s.click.aliexpress.com/e/_opvEKde

Os passos abaixo são para o IDE versão 5.4.

1 - Verificar as dependencias em:
https://github.com/Blockstream/Jade

https://github.com/Blockstream/Jade?tab=readme-ov-file#set-up-the-environment
 
2 - Instalar o Python 3.13 da loja da Microsoft
https://apps.microsoft.com/detail/9NRWMJP3717K?hl=en-us&gl=US

3 - Instalar o IDE para ESP32 (versã0 5.4)

4 - Clonar o software da Jade no Windows dentro da pasta do IDE para ESP32
Abra o prompt de comando que se encontra no desktop
```
git clone --recursive https://github.com/Blockstream/Jade.git
```
5 - Vá para pasta "Jade"

6 - Com o Explorer copie da pasta config o arquivo sdkconfig_display_ttgo_tdisplays3procamera.defaults e coloque na pasta Jade. Renomeie o arquivo para sdkconfig.defaults

7 - Com a T-Dsiplay S3 PRO plugado no computador realize a instalação do firmware do dispositivo.
```
idf.py flash monitor
```
8 - Após o termino o dispositivo reinicia ficando pronto para ser configurado.
