#!/bin/bash

#Retrieve the current version from the "alias_manager.sh" script
current_version=$(grep -wm 1 "current_version" ~/.alias_manager/alias_manager.sh | cut -f2 -d"=" | sed "s/\"//g")

#Var that determines the latest version available for the Alias Manager program (used to check if the program is up to date or not)
latest_version=$(curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/latest_release.txt)

#If an update is available, ask for a confirmation and perform the update
if [ "$current_version" != "$latest_version" ]; then
	echo "A new update is available !"
	read -n 1 -r -s -p $'Press \"enter\" to install it, or \"ctrl + c\" to abort...\n'
	
	#Update
	echo -e "\nUpdate in progress..."

	#Create the Alias Manager's working directory (if it doesn't exist)
	mkdir -p ~/.alias_manager || exit 1

	#Download all the scripts (except the "update" one because it is automatically downloaded by the "alias_manager.sh" script when performing an update)
	curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/alias_manager.sh -o ~/.alias_manager/alias_manager.sh || exit 1
	curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/add_alias_manager.sh -o ~/.alias_manager/add_alias_manager.sh || exit 1
	curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/remove_alias_manager.sh -o ~/.alias_manager/remove_alias_manager.sh || exit 1
	curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/list_alias_manager.sh -o ~/.alias_manager/list_alias_manager.sh || exit 1
	curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/uninstall_alias_manager.sh -o ~/.alias_manager/uninstall_alias_manager.sh || exit 1
	curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/readme_alias_manager.sh -o ~/.alias_manager/readme_alias_manager.sh  || exit 1
	curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/install_alias_manager.sh -o ~/.alias_manager/install_alias_manager.sh || exit 1

	#Make all the scripts executable
	chmod +x ~/.alias_manager/*.sh || exit 1

	#Echo "succesfully updated" + giving some info to the user 
	echo -e "\nThe Alias Manager program has been successfully updated to the \"$latest_version\" version\nCheck this link to read the changelog : https://github.com/Antiz96/alias_manager#changelog\n\nPlease, relaunch the Alias Manager program to switch to the new version"

else
	echo "You're already running the latest version of the Alias Manager program :)"
fi
