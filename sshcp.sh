#!/bin/bash
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
						    
								exit 0
						    		;;
							*)
						    		echo "Invalid choice. Please choose 1, 2, or 3."
						    		;;
					    	esac
					done
					
