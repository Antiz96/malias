#!/bin/bash

#Clear the screen
clear >"$(tty)"

#Ask the alias the user wants to add
read -rp "Please, type the alias name you want to add : " alias_name
read -rp "Please, type the command you want to associate your alias name with : " alias_command

#Transform the user input in the right format and ask for a confirmation
new_alias="$alias_name"=\'"$alias_command"\'
echo -e "\nThe following alias will be added : $new_alias"
read -n 1 -r -s -p $'Press \"enter\" to continue, or \"ctrl + c\" to abort...\n'

#Create a backup of the .bashrc file and add the new alias to the .bashrc file
cp -p ~/.bashrc ~/.bashrc-bck-alias_manager-"$(date +"%d-%m-%Y")" && echo -e "\nBackup of the .bashrc file created\n" || exit 1
echo "alias $new_alias" >> ~/.bashrc

#Check for potential errors
source_error=$(source ~/.bashrc 2>/dev/null; echo $?)

#If there's no error, tell the user that the alias has been successfully added and delete the backup of .bashrc file
if [ "$source_error" -eq 0 ]; then
	source ~/.bashrc && echo "Alias $new_alias successfully added" || exit 1
	rm -f ~/.bashrc-bck-alias_manager-"$(date +"%d-%m-%Y")" && echo -e "Backup of the .bashrc file deleted"

#If there's an error, print it to the user and restore the backup of the .bashrc file
else
	echo -e "An error has occurred :"
	source ~/.bashrc
	echo -e "\nPlease verify that your alias is correct and respects the following format : alias name='command'"
	echo -e "Also, be aware that your alias name cannot contain spaces. However, it can contain \"-\" (score)  or \"_\" (underscore)\n"
	mv -f ~/.bashrc-bck-alias_manager-"$(date +"%d-%m-%Y")" ~/.bashrc && echo -e "Backup of the .bashrc file restored" || exit 1
fi
