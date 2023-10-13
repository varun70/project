#!/usr/bin/bash


echo -e "\033[2J\033[H"

source logo2.sh

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

#************************************Code Starts****************************************

echo -e "$TRED Your Ip Address Are "

#!/bin/bash

center() {
    local width term_width
    width=$(echo -n "$1" | wc -c)
    term_width=$(tput cols)
    padding=$(( (term_width - width) / 2 ))
    printf "%${padding}s" " "
    echo -n "$1"
    printf "%${padding}s" " "
    echo
}

ip -4 addr show | awk '/inet / {print $NF " : " $2}' | cut -d'/' -f1 | while IFS= read -r line; do
    center "$line"
done

# Uncomment below to display IPv6 addresses as well:
# echo
# echo "IPv6 Addresses:"
# echo

# ip -6 addr show | awk '/inet6 / {print $NF " : " $2}' | cut -d'/' -f1 | while IFS= read -r line; do
#     center "$line"
# done

echo -e "$NC "

echo -e "$CYAN 1.Update\n 2.FTP\n 3.SERVER\n 4.SSH\n 5.SSH COPY\n 6.EXIT""$NC"
echo
echo -e "$GREEN BEFORE STARTING ANY SERVICE CHOOSE OPTION 1 TO UPDATE YOUR REPOSITORY TO INSTALL THE NECESSARY FILE"
echo " "
echo " "
while true
do
	echo -e "$BLUE"
	echo -n  "ENTER THE SERVICE YOU WANT: "
	read vs
	echo -e "$NC"
	if [[ "$vs" =~ ^[1-6]$ ]];then
		case $vs in
			"1")
				source update.sh
				;;
			"2")
				source setftp.sh
				;;
			"3")
				source server.sh
				;;
			"4")
				#!/bin/bash
				## Check if sshd (OpenSSH server) is installed
				if ! command -v sshd &>/dev/null; then
					echo "OpenSSH server not found. Installing..."
					# Determine the package manager and install sshd
				if command -v apt-get &>/dev/null; then
					sudo apt-get update
					sudo apt-get install -y openssh-server
				elif command -v yum &>/dev/null; then
					sudo yum install -y openssh-server
				else
					echo "Unsupported package manager. Please install OpenSSH server manually."
				       	exit 1
				fi
				fi
				# Enable and start the SSH server
				sudo systemctl enable ssh
				sudo systemctl start ssh
				echo "SSH server is now running."
				;;
			"5")
			# Simple script to facilitate SCP (secure copy over SSH)
				function copy_from_remote() {
					echo  -e "$PURPLE"
					read -p "Enter remote username: " remote_user
				       	read -p "Enter remote host (IP or hostname): " remote_host
				    	read -p "Enter path to the file on remote host: " remote_path
				    	read -p "Enter local destination path (e.g., ./localfile.txt): " local_path
				    	scp "${remote_user}@${remote_host}:${remote_path}" "$local_path"
					echo -e "$NC"
				}
				function copy_to_remote() {
					echo -e "$YELLOW"
				    	read -p "Enter remote username: " remote_user
				    	read -p "Enter remote host (IP or hostname): " remote_host
				    	read -p "Enter local source file path (e.g., ./localfile.txt): " local_path
				    	read -p "Enter destination path on the remote host: " remote_path
				    	scp "$local_path" "${remote_user}@${remote_host}:${remote_path}"
				    	echo -e "$NC"
					}
					while true; do
						echo -e "$BLUE"
					    	echo "Choose an option:"
					    	echo "1. Copy from remote host to local user"
					    	echo "2. Copy from local user to remote host"
					    	echo "3. Exit"
					    	read -p "Enter your choice (1/2/3): " choice
					    	echo -e "$NC"
					    	case $choice in
							1)
						    		copy_from_remote
						     		;;
							2)
						    		copy_to_remote
						    		;;
							3)
						    		echo "Exiting..."
						    
								exit 1
						    		;;
							*)
						    		echo "Invalid choice. Please choose 1, 2, or 3."
						    		;;
					    	esac
					done
					;;
			"6")
			      exit 0
					;;
	
	
			esac
		else
			echo -e "$RED Invalid Input. Please enter corret number""$NC"
	fi
done
