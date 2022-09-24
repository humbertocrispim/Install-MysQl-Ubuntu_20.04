#!/bin/bash

RESET='\033[0m'
YELLOW='\033[1;33m'
#GRAY='\033[0;37m'
#WHITE='\033[1;37m'
GRAY_R='\033[39m'
WHITE_R='\033[39m'
RED='\033[1;31m' # Light Red.
GREEN='\033[1;32m' # Light Green.
#BOLD='\e[1m'

###################################################################################################################################################################################################
#                                                                                                                                                                                                 #
#                                                                                           Start Checks                                                                                          #
#                                                                                                                                                                                                 #
###################################################################################################################################################################################################

header() {
  clear
  clear
  echo -e "${GREEN}#########################################################################${RESET}\\n"
}

header_red() {
  clear
  clear
  echo -e "${RED}#########################################################################${RESET}\\n"
}

# Check for root (SUDO).
if [[ "$EUID" -ne 0 ]]; then
  header_red
  echo -e "${WHITE_R}#${RESET} O script precisa ser executado como root...\\n\\n"
  echo -e "${WHITE_R}#${RESET} Execute o comando abaixo para fazer login como root"
  echo -e "${GREEN}#${RESET} sudo -i\\n"
  exit 1
fi

# Instalando Mysql-Cliente && Server
apt update -y
apt install mysql-client mysql-server -y
systemctl start mysql.service
systemctl enable mysql.service
clear
sleep 4



# Verificando se o serviço está em execução

if (systemctl -q is-active mysql.service)
    then
    echo -e "${GREEN}Tudo certo o serviço MysQl está em execução .....\\n\\n${RESET}"

else
    echo -e "${RED}Erro Serviço MysQl não iniciou ! \\n\\n${RESET}"
    exit 1
fi


# Criando base de dados
echo ====================================
echo -e "${GREEN}Criando base de dados !\\n\\n${RESET}"
echo ====================================
echo
read -p 'Database: ' datavar
mysql -e "create database $datavar character set utf8"
[ $? -ne 0 ] && echo -e "${RED}A base de dados já existe, verifique os logs! .${RESET}\\n\\n"
sleep 3

# Criando usuário
echo ====================================
echo -e "${GREEN}Criando usuário !\\n\\n${RESET}"
echo ====================================
echo
read -p 'Username: ' uservar
read -sp 'Password: ' passvar
mysql -e "create user '$uservar'@'%' identified by '$passvara'"
mysql -e "grant all privileges on $datavar.* to '$uservar'@'%' with grant option"; # Dando privilégios ao usuário



