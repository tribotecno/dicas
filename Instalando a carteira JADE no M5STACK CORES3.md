# Instalando a Carteira Jade no dispositivo M5 STACK CORE S3 #
Recomendamos usar esse tutorial com o vídeo do youtube https://youtu.be/BpVk2lKNK_c

Os passos abaixo são para o IDE versão 5.4. Como existe um atraso para atualizar os drivers do touch, utilize a versão 1.0.33

1 - Verificar as dependencias em:
https://github.com/Blockstream/Jade
https://github.com/Blockstream/Jade?tab=readme-ov-file#set-up-the-environment
 
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

Os passos abaixo são para utilizar a versão 5.3.1 do IDE enquanto não há a atualização dos drivers do touch

1 - Instalar o Python 3.11 da loja da Microsoft

2 - Desinstale a versão 5.4 e apague a pasta Jade se tiver clonado anteriormente

3 - Baixar a versão espidf 5.3 em:
```
https://dl.espressif.com/dl/esp-idf/?idf=4.4
```

4 - Clonar o repositório da versão 1.0.33
```
git clone --branch 1.0.33 https://github.com/Blockstream/Jade.git
```

5 - Baixe os módulos dependentes
```
cd Jade
git submodule update --init --recursive
```

6 - Com Explorer copie da pasta config o arquivo sdkconfig_display_m5staks3.defaults e coloque na pasta Jade. Renomeie o arquivo para sdkconfig.defaults

7 - Com o M5 Stack plugado no computador realize a instalação do programa
```
idf.py flash monitor
```

8 - Após o termino o dispositivo reinicia ficando pronto para ser configurado.

