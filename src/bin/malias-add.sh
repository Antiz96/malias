#!/bin/bash

#Ask for the new alias to add
read -rp "Please, type the alias name you want to add : " alias_name
read -rp "Please, type the command you want to associate your alias with : " alias_command

#Transform the user input in the right format and ask for a confirmation
new_alias="$alias_name"=\'"$alias_command"\'
echo -e "\nThe following alias will be added : $new_alias"
read -rp $'Do you confirm ? [Y/n] ' answer

case "$answer" in
	[Yy]|"")
		echo -e "\nAdding the new alias..."
	;;
	*)
		echo -e "\nAborting"
		exit 1
	;;
esac

#Create a backup of the .bashrc file and add the new alias
cp -p ~/.bashrc ~/.bashrc-bck_malias-add-"$alias_name"-"$(date +"%d-%m-%Y")" && echo -e "\nBackup of the .bashrc file created\n" || exit 1
echo "alias $new_alias" >> ~/.bashrc

#Check for potential errors
source_error=$(bash -x ~/.bashrc 2>/dev/null; echo $?)

#If there's no error, tell the user that the alias has been successfully added and delete the backup of .bashrc file
if [ "$source_error" -eq 0 ]; then
	echo "Alias $new_alias successfully added"
	rm -f ~/.bashrc-bck_malias-add-"$alias_name"-"$(date +"%d-%m-%Y")" && echo "Backup of the .bashrc file deleted"
	exec bash
#If there's an error, inform the user and restore the backup of the .bashrc file
else
	echo -e "An error has occurred"
	echo -e "\nPlease verify that your alias is correct and that it respects the following format : alias_name='command'"
	echo -e "Also, be aware that your alias name cannot contain space(s)\nHowever, it can contain \"-\" (score) or \"_\" (underscore)\n"
	mv -f ~/.bashrc-bck_malias-add-"$alias_name"-"$(date +"%d-%m-%Y")" ~/.bashrc && echo "Backup of the .bashrc file restored" || echo -e "WARNING : A problem occurred when restoring the backup of your ~/.bashrc file\nPlease, check for potential errors in it"
	exit 1
fi
