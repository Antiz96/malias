#!/bin/bash

#Get the number of current aliases
alias_number=$(grep -wc "^alias" ~/.bashrc)

#Get the list of current aliases...
alias_list=$(grep -w "^alias" ~/.bashrc | awk '{$1=""}1' | sed "s/ //")

#...and reformat it correctly with a unique number in front of each aliases
echo -e "Alias list :\n"
i=1
while IFS= read -r line; do
	echo "$i - $line"
	((i=i+1))
done < <(printf '%s\n' "$alias_list")

#Ask the user which alias he wants to delete
read -rp $'\nPlease, type the number associated to the alias you want to remove : ' alias_selected

#If the number selected by the user is correct (meaning the number selected is less than or equal to the number of current aliases and greater than 0), create a backup of the .bashrc file and delete the associated alias in the .bashrc file + unalias the alias
if [ "$alias_selected" -le "$alias_number" ] && [ "$alias_selected" -gt "0" ]; then

	#Extract the alias associated to the number selected by the user in the right format and ask for a confirmation
	alias_delete=$(sed -n "$alias_selected"p <<< "$alias_list")
	alias_name=$(echo "$alias_delete" | cut -f1 -d"=")
	echo -e "\nThe following alias will be deleted : $alias_delete"
	read -rp $'Do you confirm ? [y/N] ' answer
	
	case "$answer" in
		[Yy])
			echo -e "\nDeleting the alias..."
		;;
		*)
			echo -e "\nAborting"
			exit 1
		;;
	esac

	#Create a backup of the .bashrc file and delete the selected alias
	cp -p ~/.bashrc ~/.bashrc-bck_malias-delete-"$alias_name"-"$(date +"%d-%m-%Y")" && echo -e "\nBackup of the .bashrc file created\n" || exit 1
	sed -i "/^alias $alias_delete$/d" ~/.bashrc || exit 1

	#Check for potential errors
	source_error=$(bash -x ~/.bashrc 2>/dev/null; echo $?)

	#If there's no error, delete the alias and delete the .bashrc backup file
	if [ "$source_error" = 0 ]; then
		echo "Alias $alias_delete successfully deleted" || exit 1
		rm -f ~/.bashrc-bck_malias-delete-"$alias_name"-"$(date +"%d-%m-%Y")" && echo "Backup of the .bashrc file deleted"
		exec bash

	#If there's an error, inform the user and restore the backup file
	else
		echo "An error has occurred"
		mv -f ~/.bashrc-bck_malias-delete-"$alias_name"-"$(date +"%d-%m-%Y")" ~/.bashrc && echo "Backup of the .bashrc file restored" || echo -e "WARNING : A problem occurred when restoring the backup of your ~/.bashrc file\nPlease, check for potential errors in it"
		exit 1
	fi
#If the number selected by the user is wrong, print an error and quit Malias
else
	echo -e "\nError : Invalid input\nPlease, make sure you typed the correct number associated to the alias you want to delete\n"
	echo  "The \"delete\" operation has been aborted"
	exit 1
fi
