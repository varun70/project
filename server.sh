#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
NC="\e[0m"

function system_updates_and_patching {
    echo -e "${CYAN}Updating system and applying patches...${NC}"
    apt update && apt install htop vsftpd openssh-server ufw -y && apt dist-upgrade -y && apt autoremove -y && apt autoclean -y && echo -e "${GREEN}System updated and patched.${NC}" || echo -e "${RED}Update and Patching Failed.${NC}"
}

function user_management {
    echo -e "${CYAN}User Management Section...${NC}"
    echo -e "${BLUE}1. Add user${NC}"
    echo -e "${BLUE}2. Remove user${NC}"
    read -p "Choose option: " choice
    read -p "Enter username: " username
    case $choice in
        1) adduser $username ;;
        2) deluser --remove-home $username ;;
        *) echo -e "${RED}Invalid choice.${NC}" ;;
    esac
}

function service_management {
    echo -e "${CYAN}Service Management Section...${NC}"
    echo -e "${BLUE}1. Start service${NC}"
    echo -e "${BLUE}2. Stop service${NC}"
    echo -e "${BLUE}3. Restart service${NC}"
    echo -e "${BLUE}4. Check service status${NC}"
    read -p "Choose option: " choice
    read -p "Enter service name: " service
    case $choice in
        1) systemctl enable $service ;systemctl start $service ;;
        2) systemctl stop $service ; systemctl disable $service ;;
        3) systemctl restart $service ;;
        4) systemctl status $service ;;
        *) echo -e "${RED}Invalid choice.${NC}" ;;
    esac
}

function security {
    echo -e "${CYAN}Configuring Security...${NC}"
    ufw enable && ufw status verbose
}

function resource_monitoring {
    echo -e "${CYAN}Monitoring System Resources...${NC}"
    htop || echo -e "${RED}htop is not installed. Consider installing it for a more detailed view.${NC}"
}

function backup_and_recovery {
    echo -e "${CYAN}Backup Section...${NC}"
    read -p "Enter directory to backup: " dir
    tar -cvzf backup.tar.gz $dir && echo -e "${GREEN}Backup created.${NC}" || echo -e "${RED}Backup Failed.${NC}"
}

function network_management {
    echo -e "${CYAN}Network Management Section...${NC}"
    nmcli || echo -e "${RED}Network Manager is not installed.${NC}"
}

function sys_info {
    echo "System Information for $HOSTNAME"
            echo "Operating System: $(uname)"
            echo "Kernel Version: $(uname -r)"
            echo "Uptime: $(uptime)"
}

function file_system_display {
    echo -e "${CYAN}File System Management Section...${NC}"
    df -hT || echo -e "${RED}Error showing disk usage.${NC}"
}

while true; do
    echo -e "${YELLOW}Server Management Tool${NC}"
    echo -e "${BLUE}1. SYS INFO${NC}"
    echo -e "${BLUE}2. System Updates and Patching${NC}"
    echo -e "${BLUE}3. User Management${NC}"
    echo -e "${BLUE}4. Service Management${NC}"
    echo -e "${BLUE}5. Security${NC}"
    echo -e "${BLUE}6. Resource Monitoring${NC}"
    echo -e "${BLUE}7. Backup and Recovery${NC}"
    echo -e "${BLUE}8. Network Management${NC}"
    echo -e "${BLUE}9. File System Display${NC}"
    echo -e "${RED}10. Exit${NC}"
    read -p "Enter your choice: " choice
    
    case $choice in
        1)  sys_info;;
        2)  system_updates_and_patching ;;
        3)  user_management  ;;
        4) service_management  ;;
        5) security  ;;
        6) resource_monitoring  ;;
        7) backup_and_recovery  ;;
        8) network_management  ;;
        9) file_system_display ;;
        10) break ;;
        *) echo -e "${RED}Invalid choice.${NC}" ;;
    esac
done
