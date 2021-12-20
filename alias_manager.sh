#!/bin/bash

###################################################################################################################
#Description : alias_manager is a program that helps you manage your aliases                               	  #
#Author : Robin Candau                                                                                            #
#Links : https://rc-linux.com/ - https://github.com/Antiz96 - https://www.linkedin.com/in/robin-candau-3083a2173/ #
###################################################################################################################

#Var that determines the current version of the Alias Manager program (used in the "update" section to check if the program is up to date or not)
current_version="2.1"

#Vars that verifies if curl is installed on the machine and if the machine is connected to the internet (prerequisites for the "update" function)
curl_status=$(which curl > /dev/null && echo "ok")
internet_status=$(curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/latest_release.txt > /dev/null && echo "ok")

#Var that determines whether if the program is going to relaunch or not. The entire program is encapsulated into a "while" loop determined by this var
relaunch="y"

while [ "$relaunch" = "y" ]; do

	#Reset the relaunch var
	unset relaunch

	#Clear the screen
        clear >"$(tty)"

	echo -e "Hello and welcome to the Alias Manager !\nYou're currently using the \"$current_version\" version\n"
	echo "Please, type one of the following options : "
	echo "add           (Adding an new alias)"
	echo "remove        (Removing an alias)"
	echo "list          (List all your current aliases)"
	echo "update        (Update the Alias Manager program)"
	echo "uninstall     (Uninstall the Alias Manager program)"
	echo "readme        (Display some information about the Alias Manager program)"
	echo "exit          (Quit the Alias Manager program)"

	if [ "$curl_status" = "ok" ] && [ "$internet_status" = "ok" ]; then
		latest_version=$(curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/latest_release.txt)
		if [ "$current_version" != "$latest_version" ]; then
			echo -e "\n--A new update is available, type \"update\" to download it !--"
		fi
	fi
	
	read -rp $'\nWhat do you want to do ? : ' action
	action=$(echo "$action" | awk '{print tolower($0)}')

	case "$action" in
		add)
			source ~/.alias_manager/add_alias_manager.sh
		;;
		remove)
			source ~/.alias_manager/remove_alias_manager.sh

			#If the number selected by the user in the "remove_alias_manager.sh" script is wrong, relaunch the Alias Manager program
			if [ "$?" -eq 1 ]; then
				relaunch="y"
			fi
		;;
		list)
			source ~/.alias_manager/list_alias_manager.sh
		;;
		update)
			clear >"$(tty)"

			echo -e "Checking for available update...\n"

			#If "curl" is not installed on the machine, print an error to the user 
			if [ "$curl_status" != "ok" ]; then
				echo "Error : It looks like \"curl\" is not installed on your machine"
			fi

			#If the machine cannot access to "github.com", print an error to the user
			if [ "$internet_status" != "ok" ]; then
				echo "Error : It looks like your machine is not connected to the internet (or do not have access to \"github.com\")"
			fi

			#If "curl" is not installed or the machine is not connected to the internet (or both), abort update and relaunch the Alias Manager program
			if [ "$curl_status" != "ok" ] ; [ "$internet_status" != "ok" ]; then
				echo -e "Please, make sure \"curl\" is installed and your machine is connected to the internet\n"
				echo -e "The update process has been aborted\n"
				read -n 1 -r -s -p $'Press \"enter\" to restart the Alias Manager program, or \"ctrl + c\" to quit...\n'
				relaunch="y"
			#Otherwise, download the lastest update script and launch it
			else
				curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/update_alias_manager.sh -o ~/.alias_manager/update_alias_manager.sh && chmod +x ~/.alias_manager/update_alias_manager.sh && source ~/.alias_manager/update_alias_manager.sh || exit 1
				#If an update has been applied, stop the Alias Manager program (so the user car relaunch it to switch to the new version)
				if [ "$?" -eq 1 ]; then
					relaunch="n"
				fi
			fi
		;;
		uninstall)
			clear >"$(tty)"

			#Ask for a confirmation
			echo "You're about to uninstall the Alias Manager program"
			read -n 1 -r -s -p $'Press \"enter\" to continue, or \"ctrl + c\" to abort...\n'
			source ~/.alias_manager/uninstall_alias_manager.sh
			relaunch="n"
		;;
		readme)
			source ~/.alias_manager/readme_alias_manager.sh
		;;
		exit)
   			#Just quitting the program
			echo -e "\nGoodbye !"
			relaunch="n"
		;;
		*)
			clear >"$(tty)"

			#Print and error and restart the program
			echo "Error : Invalid input"
			echo "The Alias Manager program will restart automatically in a few seconds"
			sleep 8
			relaunch="y"
		;;
		esac
		
	#Ask the user if he wants to relaunch the program to perform another action
	if [ -z "$relaunch" ]; then
		read -rp $'\nDo you wish to do another action ? (yes/no) : ' answer
		answer=$(echo "$answer" | awk '{print tolower($0)}')
			
		case "$answer" in
			y|yes)
				relaunch="y"
			;;
			n|no)
				echo -e "\nGoodbye !"
				relaunch="n"
			;;
			*)
				echo -e "\nError, the program expected \"yes\" or \"no\"\nStopping the Alias Manager program"
				relaunch="n"
			;;
		esac
	fi
done
