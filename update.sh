#!/usr/bin/bash

# COLOURS

WHITE="\033[1;37m"
GREY="\033[0;37m"
PURPLE="\033[0;35m"
TRED="\033[1;31m"
RED="\e[31m"
GREEN="\e[32m"
BOLDGREEN="\e[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m"
CYAN="\033[1;36m"

#Checking if root user or not

if [ $EUID -ne 0 ]
then
	echo -e "$TRED TERMINATED""$YELLOW,Please Execute As Root User""$NC"
	exit 1
fi

function update() {
	echo -e "$YELLOW*********************************""$RED UPDATING THE SYSTEM""$YELLOW***********************************"
	sudo apt-get update && sudo apt-get dist-upgrade -y
	sudo apt install ufw -y
	echo -e "$YELLOW**********************************""$RED UPDATE IS COMPLETE""$YELLOW***********************************""$NC"
}

update
