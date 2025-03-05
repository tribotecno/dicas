# Instalando a Carteira Jade no dispositivo T-DISPLAY S3 PRO #
Recomendamos usar esse tutorial com o vídeo do youtube https://youtu.be/BpVk2lKNK_c

Para adquirir o M5Stack Core S3 utilize o nosso link:

<a href="https://s.click.aliexpress.com/e/_opvEKde" target="_blank" rel="noopener noreferrer">T-Display S3 Pro</a>

[Open in New Window](https://s.click.aliexpress.com/e/_opvEKde)

Os passos abaixo são para o IDE versão 5.4. Como existe um atraso para atualizar os drivers do touch, utilize a versão 1.0.33

1 - Verificar as dependencias em:
[Open in New Window](https://github.com/Blockstream/Jade)

[Open in New Window](https://github.com/Blockstream/Jade?tab=readme-ov-file#set-up-the-environment)
 
2 - Instalar o Python 3.11 da loja da Microsoft
https://apps.microsoft.com/detail/9NRWMJP3717K?hl=en-us&gl=US

3 - Instalar o IDE para ESP32 (versã0 5.4)

4 - Clonar o software da Jade no Windows dentro da pasta do IDE para ESP32
Abra o prompt de comando que se encontra no desktop
```
git clone --recursive https://github.com/Blockstream/Jade.git
```
5 - Vá para pasta "Jade"

6 - Com Explorer copie da pasta config o arquivo sdkconfig_display_m5staks3.defaults e coloque na pasta Jade. Renomeie o arquivo para sdkconfig.defaults

7 - Com o M5 Stack plugado no computador realize a instalação do programa
```
idf.py flash monitor
```
8 - Após o termino o dispositivo reinicia ficando pronto para ser configurado.
