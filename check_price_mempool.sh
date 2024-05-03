#!/bin/bash
#
# Script para monitoramento da cotação feito pela Tribo Tecno
#
# Coloque no seu crontab (crontab -e) a linha de chamada do script
# */50 * * * * /home/seuusuario/check_price_mempool.sh 
# Para ver mais emoticon https://apps.timwhitlock.info/emoji/tables/unicode
#
#
#Pega cotação na mempool.space
output=$(curl -sSL "https://mempool.space/api/v1/prices")
#Acumula o preço e data da cotação
TIMESTAMP=$(echo $output |cut -d"," -f1|cut -d":" -f2)
BTCUSD=$(echo $output |cut -d"," -f2|cut -d":" -f2)
#Transforma cotação e data para formato do serumaninho
DATA=$(date --rfc-2822 -d @$TIMESTAMP)
USDCONV=$(printf "USD %'.2f\n" $BTCUSD)
#Cria os emoticons para o Telegram
RINDO=$(echo  -e '\U0001F603')
TRISTE=$(echo  -e '\U0001F630')

#Variaveis do Telegram. Altere para o seu bot criado
CHATID=9999999
URLTEL=https://api.telegram.org/bot99999999:ZZZZZZZZZZZZZZZZZZZZZZZZZ/sendMessage

# Check das variaveis ativar em caso de debug
#echo $TIMESTAMP
#echo $DATA
#echo $BTCUSD
#echo $USDCONV
#echo $RINDO
#echo $TRISTE
#echo $CHATID
#echo $URLTEL

# Modifique os valores para contação a verificar em USD
CHECKHIGH=75000
CHECKLOW=55000

  if [[ $BTCUSD -ge $CHECKHIGH ]]
        then
        echo "  "
        /usr/bin/curl -4 -X POST --data chat_id=$CHATID --data parse_mode="markdown" --data text="Alerta cotação!! O BTC QUEBROU o check e está valendo $USDCONV agora em $DATA ! $RINDO " $URLTEL
 elif [[ $BTCUSD -le $CHECKLOW ]]
        then
        echo "  "         
        /usr/bin/curl -4 -X POST --data chat_id=$CHATID --data parse_mode="markdown" --data text="Alerta cotação!! O BTC CAIU para $USDCONV em $DATA ! $TRISTE " $URLTEL
fi


        
