# Principais comandos usados no Umbrel para o node Bitcoin e Lightning
#Insira as linhas abaixos no seu arquivo bash_aliases
#comando: nano .bash_aliases
#Os comandos são autoexplicativos e vc poderá acrescentar mais linhas para personalizar sua configuração
#
alias bitcoindlog="tail -f ~/umbrel/app-data/bitcoin/data/bitcoin/debug.log"
alias lndlog="tail -f ~/umbrel/app-data/lightning/data/lnd/logs/bitcoin/mainnet/lnd.log"
alias karenlog="tail -f ~/umbrel/logs/karen.log"
alias lndrestart="sudo ~/umbrel/scripts/app restart lightning"
alias lndstop="sudo ~/umbrel/scripts/app stop lightning"
alias lndstart="sudo ~/umbrel/scripts/app start lightning"
alias lightermrestart="sudo ~/umbrel/scripts/app restart lightning-terminal"
alias umbrelstop="sudo ~/umbrel/scripts/stop"
alias umbrelstart="sudo ~/umbrel/scripts/start"
alias lndedit="vim ~/umbrel/app-data/lightning/data/lnd/lnd.conf"
alias lndtowerinfo="sudo ~/umbrel/scripts/app compose lightning exec lnd lncli tower info"
alias lndpendchannel="sudo ~/umbrel/scripts/app compose lightning exec lnd lncli pendingchannels"
alias lndgetinfo="sudo ~/umbrel/scripts/app compose lightning exec lnd lncli getinfo"
#os comandos abaixo permitem a inserção de um parametro
alias lndcliente="sudo ~/umbrel/scripts/app compose lightning exec lnd lncli" $1
alias lightning-cli="sudo ~/umbrel/scripts/app compose lightning exec lnd lncli" $1
alias lncli="sudo ~/umbrel/scripts/app compose lightning exec lnd lncli" $1
#edite o seuhome para a sua pasta de home bem como o discodestino 
#No list.txt sugerimos colocar a pasta do bitcoin "umbrel/app-data/bitcoin/"
alias backconf="rsync -av --exclude-from='list.txt' /home/seuhome/umbrel/ /mnt/discodestino/umbrel/"
alias ajuda="clear && cat ~/.bash_aliases|cut -d"=" -f1"
