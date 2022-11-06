#!/bin/bash

#VARIAVEIS
ARC=$(uname -a)
CPU=$(lscpu | grep "CPU(s)" | head -1 | tr -s ' ')
vCPU=$(cat /proc/cpuinfo | grep processor | wc -l)

#PROCESSADOR
PRCS=$(top -bn1 | awk '/Cpu/ {print $2}')

#STORAGE
STR_USED=$(df -Bm | grep /dev/ | grep -v /boot | awk '{ud += $3} END {print ud}')
STR_TOTAL=$(df -Bg | grep /dev/ | grep -v /boot | awk '{fd += $2} END {print fd}')
STR_PERC=$(df -Bm | grep /dev/ | grep -v /boot | awk '{ud += $3} {fd += $2} END {printf("%d"), ud/fd * 100}')

#RAM
RAM_USED=$(free -m | grep Mem | awk '{print $3}')
RAM_TOTAL=$(free -m | grep Mem | awk '{print $2}')
RAM_PERC=$(free -m | grep Mem | awk '{printf ("%0.2f"), $3 / $2 * 100}')

#LVM
LVM_USED=$(lsblk -f | grep LVM -oq && echo yes || echo no)

#REGISTRO DA ÚLTIMA REINICIALIZAÇÃO
LST_BOOT=$(who -b | tr -s ' ' | cut -d ' ' -f5,6)

#ENDEREÇO IPv4 E ENDEREÇO MAC
IP=$(hostname -I | cut -d ' ' -f1)
MAC=$(ip address | grep ether | cut -d ' ' -f6)

#CONEXÕES ATIVAS
#CNX_TCP=$(ss -s | grep TCP | sed -n '1 p' | tr -s ' ' | cut -d ' ' -f2)
CNX_TCP=$(ss -s | grep -o '(estab [[:digit:]]*' | sed -r 's/\(estab //' | sed 's/$/ ESTABILISHED/')

#USUARIOS LOGADOS
USERS=$(users | wc -l)

#NUMERO DE COMANDOS EXECUTADOS COM SUDO
SUDO=$(cat /var/log/sudo/sudo.log | grep -c -i "COMMAND=")

wall "
#Architecture: $ARC
#$CPU
#vCPU: $vCPU
#Memory Usage: $RAM_USED/${RAM_TOTAL}MB ($RAM_PERC%)
#Disck Usage: $STR_USED/${STR_TOTAL}Gb ($STR_PERC%)
#CPU load: $PRCS%
#Last boot: $LST_BOOT
#LVM use: $LVM_USED
#Connection TCP: $CNX_TCP
#User log: $USERS
#Network: IP $IP ($MAC)
#Sudo: $SUDO cmd
" 
