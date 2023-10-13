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


# Check User Is root Or Not

if [ "$EUID" -ne 0 ]
then
	echo -e "$TRED TERMINATED""$YELLOW, Please Run The Script As Root""$NC"
	exit 1
fi

#Install The vsftpd

if ! command -v vsftpd &> /dev/null
then
	echo "$CYAN Installing vsftpd....""$NC"
	apt-get update
	apt-get install vsftpd -y
fi

#Enabling vsftpd
echo -e  "$TRED"

systemctl enable vsftpd
echo -e " "

#Staring vsftpd
echo -e "$NC"

systemctl start vsftpd

echo -e "$BLUE********************************************** Service Started ************************************************************""$NC"

# Create a new user and set password
function create_user() {
  echo -e "$PURPLE"
  read -p "Enter the username for the new FTP user: " USERNAME
  echo -e "$NC"

  # Check if the user already exists
  if id "$USERNAME" &>/dev/null; then
    echo -e "$RED"
    echo "User '$USERNAME' already exists."
    echo -e "$NC"
    echo -e "$YELLOW"
    read -p "Do you want to create another user or use the last created user? (new/last/remove/stop): " CHOICE
    echo -e "$NC"

    if [[ $CHOICE == "new" ]]; then
      create_user
    elif [[ $CHOICE == "last" ]]; then
      find_last_user
    elif [[ $CHOICE == "remove" ]]; then
      remove_user
    else [[ $CHOICE == "stop" ]]
	    stops
      exit 0
    fi
  else
    read -s -p "Enter the password for the new FTP user: " PASSWORD
    echo

    # Create a new user
    useradd -m "$USERNAME"

    # Set the user's password
    echo "$USERNAME:$PASSWORD" | chpasswd
    echo -e "$BLUE"
    chown ftp:$USERNAME /home/$USERNAME
    if grep -q '#chroot_local_user=YES' /etc/vsftpd.conf; then
	    echo "YES"
    fi
    if ! command -v ufw &> /dev/null; then
	    sudo apt install ufw -y > /dev/null
    fi
    sudo ufw allow ftp >/dev/null
    sudo ufw enable > /dev/null
    sudo ufw status
    echo -e  "FTP user '$USERNAME' has been created with the specified password.""$NC"
  fi
}

# Find the last user created on the system
function find_last_user() {
  LAST_USER=$(grep -Eo '^[^:]+:[^:]+:[0-9]{4}' /etc/passwd | cut -d: -f1 | sort | tail -n 1)

  if [[ -n $LAST_USER ]]; then
    echo -e "$RED The last user created on the system is: $LAST_USER""$NC"
  else
    echo -e "$RED No users found on the system.""$NC"
  fi
}

# Remove a user
function remove_user() {
  echo -e "$GREEN"
  read -p "Enter the username of the user to remove: " USERNAME
  echo -e "$NC"

  # Check if the user exists
  if id "$USERNAME" &>/dev/null; then
    # Remove the user and their home directory
    echo -e "$GREY"
    userdel  "$USERNAME"
    userdel -r "$USERNAME"
    echo -e "$BLUE"
    rm -rf "/home/$USERNAME"
    sudo ufw deny ftp > /dev/null
    sudo ufw disable
    echo "$NC"
    echo -e "$TRED User '$USERNAME' has been removed.""$NC"
  else
    echo -e "$TRED User '$USERNAME' does not exist.""$NC"
  fi
}

function stops() {
	echo -e "$TRED"
	sudo systemctl stop vsftpd > /dev/null
	sudo systemctl disable vsftpd > /dev/null
	sudo ufw disable
        echo -e "$NC"	
}

# Main menu
echo -e "$YELLOW"
echo "Do you want to create a New FTP user or use the last created user? (new/last/remove/stop)"
echo -e "$BLUE"
read -p "Enter your choice (new/last/remove/stop): " CHOICE
echo -e "$NC"

if [[ $CHOICE == "new" ]]; then
  create_user
elif [[ $CHOICE == "last" ]]; then
  find_last_user
elif [[ $CHOICE == "remove" ]]; then
  remove_user
else [[ $CHOICE == "stop" ]] 
	stops
  echo -e "$BLUE Stoping"
fi
#Restart vsftpd to apply changes

systemctl restart vsftpd
echo -e "$BLUE"
echo -e "$BLUE******************************************** Your Service Is Done ************************************************""$NC"
