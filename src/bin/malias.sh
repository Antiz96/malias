#!/bin/bash

#Replace the $1 var by "option" just to make the script more readable/less complex
option="$1"

case "$option" in
	#If the -m (or --menu) or empty option is passed to the "malias" command, execute the main "menu" function
	-m|--menu|"")
		#Clear the screen
		clear >"$(tty)"

		#Print the possible operations to the user
		echo -e "Hello and welcome to Malias !\n"
		echo "Please, type one of the following operations :"
		echo "add           (Adding a new alias)"
		echo "list          (List all your current aliases)"
		echo "delete        (Deleting an existing alias)"
		echo "help          (Print the help)"
		echo "quit          (Quit Malias)"

		#Catch the operation selected by the user
		read -rp $'\nWhat operation do you want to do ? : ' operation
		operation=$(echo "$operation" | awk '{print tolower($0)}')

		case "$operation" in
			#If the "a" (or "add") operation is selected, set the option ($1) to -a (--add)
			a|add)
				option="--add"
				clear >"$(tty)"
			;;
			#If the "l" (or "list") operation is selected, set the option ($1) to -l (--list)
			l|list)
				option="--list"
				clear >"$(tty)"
			;;
			#If the "d" (or "delete") operation is selected, set the option ($1) to -d (--delete)
			d|delete)
				option="--delete"
				clear >"$(tty)"
			;;
			#If the "h" (or "help") operation is selected, se the option ($1) to -h (--help)
			h|help)
				option="--help"
				clear >"$(tty)"
			;;
			#If the "q" (or "quit") operation is selected, quit Malias
			q|quit)
				echo -e "\nGoodbye !"
				exit 0
			;;
			#If any other strings or characters are typed, print an error and quit Malias
			*)
				echo "malias : invalid option -- '$operation'"
				echo "Try 'malias --help' for more information."
				exit 1
			;;
		esac
esac

case "$option" in
	#If the -a (or --add) option is passed to the "malias" command, execute the "malias-add" script
	-a|--add)
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
	;;
	#If the -l (or --list) option is passed to the "malias" command, execute the "malias-list" script
	-l|--list)
		#Get the list of current aliases...
		alias_list=$(grep -w "^alias" ~/.bashrc | awk '{$1=""}1' | sed "s/ //")
	
		#...and reformat it correctly with a unique number in front of each aliases
		echo -e "Alias list :\n"
		i=1
		while IFS= read -r line; do
		        echo "$i - $line"
			((i=i+1))
		done < <(printf '%s\n' "$alias_list")
	;;
	#If the -d (or --delete) option is passed to the "malias" command, execute the "malias-delete" script
	-d|--delete)
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
	;;
	#If the -h (or --help) option is passed to the "malias" command, print the help
	-h|--help)
		man malias | col
		exit 0
	;;
	#If any other strings or characters are typed, print an error and quit Malias
	*)
		echo "malias : invalid option -- '$option'"
		echo "Try 'malias --help' for more information."
		exit 1
	;;
esac
