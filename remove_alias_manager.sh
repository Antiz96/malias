#!/bin/bash

#Clear the screen
clear >"$(tty)"

#Extract the alias list in a temporary file, excluding the "alias_manager" specific alias, so the user can't delete it (otherwise this program won't work anymore by simply typing the "alias_manager" command)
alias | grep -v "alias alias_manager='source ~/.alias_manager/alias_manager.sh'" | awk '{$1=""}1' | sed "s/ //" > ~/.alias_manager/.alias_list.txt || exit 1

#Print the alias list with a unique number in front of each aliases, so the user can select the alias to delete by simply typing its associated number
echo -e "Alias list :\n"
alias_number=$(wc -l ~/.alias_manager/.alias_list.txt | awk '{print $1}')
i=1
until [ "$i" -gt "$alias_number" ]; do
	echo "$i - $(sed -n "$i"p ~/.alias_manager/.alias_list.txt)" || exit 1
	((i=i+1))
done

#Ask the user which alias he wants to delete
read -rp $'\nPlease, select the number associated to the alias you want to remove : ' alias_selected

#If the number selected by the user is correct, create a backup of the .bashrc file and delete the associated alias in the .bashrc file + unalias the alias
if [ "$alias_selected" -le "$alias_number" ] && [ "$alias_selected" -gt "0" ]; then

	#Extract the alias associated to the number selected by the user in the right format and ask for a confirmation
	alias_remove=$(sed -n "$alias_selected"p ~/.alias_manager/.alias_list.txt)
	alias_unalias=$(echo "$alias_remove" | cut -f1 -d"=")
	echo -e "\nThe following alias will be removed : $alias_remove"
	read -n 1 -r -s -p $'Press \"enter\" to continue, or \"ctrl + c\" to abort...\n'

	#Create a backup of the .bashrc file and remove the selected alias
	cp -p ~/.bashrc ~/.bashrc-bck-alias_manager-"$(date +"%d-%m-%Y")" && echo -e "\nBackup of the .bashrc file created\n" || exit 1
	sed -i "/^alias $alias_remove$/d" ~/.bashrc || exit 1

	#Check for potential errors
	source_error=$(source ~/.bashrc 2>/dev/null; echo $?)
	unalias_error=$(unalias "$alias_unalias" 2>/dev/null; echo $?)

	#If there's no error, remove the alias, delete the .bashrc backup file and delete the temporary file containing the alias list
	if [ "$unalias_error" = 0 ] && [ "$source_error" = 0 ]; then
		unalias "$alias_unalias" && echo "Unalias successful" || exit 1
		source ~/.bashrc && echo "Alias $alias_remove successfully removed" || exit 1
		rm -f ~/.bashrc-bck-alias_manager-"$(date +"%d-%m-%Y")" && echo -e "Backup of the .bashrc file deleted"
		rm -f ~/.alias_manager/.alias_list.txt

	#If there's an error, print it to the user and restore the backup file
	else
		echo -e "An error has occurred :"
		unalias "$alias_unalias" ; source ~/.bashrc
		mv -f ~/.bashrc-bck-alias_manager-"$(date +"%d-%m-%Y")" ~/.bashrc && echo -e "\nBackup of the .bashrc file restored" || exit 1
		rm -f ~/.alias_manager/.alias_list.txt
	fi
#If the number selected by the user is wrong, print an error and relaunch the program (via the "alias_manager.sh" script)
else
	echo -e "\nError : Invalid input\nPlease, make sure to select the number associated to the alias you want to remove\n"
	echo -e "The \"remove\" action has been aborted\n"
	rm -f ~/.alias_manager/.alias_list.txt
	read -n 1 -r -s -p $'Press \"enter\" to restart the Alias Manager program, or \"ctrl + c\" to quit...\n'
	return 1
fi
