# Instalando a Carteira Jade no Lilygo T-Display #
Recomendamos usar esse tutorial com o vídeo https://youtu.be/NfLLxGz-uGo
Passos para instalação
0 - Verificar as dependencias em:
https://github.com/Blockstream/Jade

1 - Baixar o drive da placa
https://www.wch-ic.com/downloads/CH343SER_ZIP.html

2 - Instalar o Python 3.11 da loja da Microsoft
https://apps.microsoft.com/detail/9NRWMJP3717K?hl=en-us&gl=US

3 - Instalar o IDE para ESP32 (versã0 5.1.2)
https://github.com/espressif/idf-installer/releases/tag/offline-5.1.2

4 - Clonar o software da Jade no Windows dentro da pasta do IDE para ESP32
Abra o prompt de comando que se encontra no desktop
git clone --recursive https://github.com/Blockstream/Jade.git

5 - Vá para pasta "Jade"

6 - Com Explorer copie da pasta config o arquivo sdkconfig_display_ttgo_tdisplay.defaults e coloque na pasta Jade. Renomeie o arquivo para sdkconfig.defaults

7 - Com placa T-Display plugada no computador realize a instalação do programa
idf.py flash monitor

8 - Após o termino o dispositivo reinicia ficando pronto para ser configurado
