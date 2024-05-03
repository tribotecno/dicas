#!/bin/bash
#
# Script para monitoramento da taxas da blockchain do Bitcoin feito pela Tribo Tecno
# Colque no seu crontab a chamada do script
# */30 * * * * /home/seuusuario/check_fee_mempool.sh
#
output=$(curl -sSL "https://mempool.space/api/v1/fees/recommended")
FASTFEE=$(echo $output |cut -d"," -f1|cut -d":" -f2)
#echo $output
#echo $FASTFEE

#Variaveis do Telegram. Altere para o seu bot criado
CHATID=9999999
URLTEL=https://api.telegram.org/bot99999999:ZZZZZZZZZZZZZZZZZZZZZZZZZ/sendMessage

FEEDREAM=5

if [[ $FASTFEE -gt $FEEDREAM ]]
           then
        echo " "           
        #echo "FASTFEE is greater than FEEDREAM"
           else
        echo "  "         
        #echo "FASTFEE less than or equal to FEEDREAM!"
        /usr/bin/curl -4 -X POST --data chat_id=$CHATID --data parse_mode="markdown" --data text="As taxas da mempool estão em $FASTFEE sats/vB! " $URLTEL
fi

