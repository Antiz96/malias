#!/bin/bash

#Variables definition
version="1.2.1"
argument="${1}"
bonjour="hello"
#Definition of the version function: Print the current version
version() {
	echo "${version}"
}

#Definition of the help function: Print the help message
help() {
	man malias | col
}

#Definition of the invalid_argument function: Print an error message, ask the user to check the help and exit
invalid_argument() {
	echo -e >&2 "malias : invalid argument -- '${operation}'\nTry 'malias --help' for more information."
	exit 1
}

#Definition of the menu function: Print a menu that lists possible operations for the user to choose from
menu() {
	clear >"$(tty)"

	echo "Welcome to Malias!"
	echo
	echo "Please, type one of the following operations:"
	echo "add           (Add a new alias)"
	echo "list          (List all your current aliases)"
	echo "delete        (Delete an existing alias)"
	echo "help          (Print the help)"
	echo "quit          (Quit Malias)"

	read -rp $'\nWhat operation do you want to do? ' operation
	operation=$(echo "${operation}" | awk '{print tolower($0)}')

	case "${operation}" in
		a|add)
			argument="--add"
		;;
		l|list)
			argument="--list"
		;;
		d|delete)
			argument="--delete"
		;;
		h|help)
			argument="--help"
		;;
		q|quit)
			echo -e "\nGoodbye !"
			exit 0
		;;
		*)
			invalid_argument
		;;
	esac

	clear >"$(tty)"
}

#Definition of the add function: Add a new alias
add() {
	read -rp "Please, type the alias name you want to add: " alias_name
	read -rp "Please, type the command you want to associate your alias with: " alias_command

	new_alias="${alias_name}"=\'"${alias_command}"\'
	echo -e "\nThe following alias will be added: ${new_alias}"
	read -rp $'Do you confirm? [Y/n] ' answer

	case "${answer}" in
		[Yy]|"")
			echo -e "\nAdding the \"${new_alias}\" alias"
		;;
		*)
			echo -e >&2 "\nAborting"
			exit 1
		;;
	esac

	cp -p ~/.bashrc ~/.bashrc-bck_malias-add-"${alias_name}"-"$(date +"%d-%m-%Y")" && echo -e "\nBackup of the .bashrc file created" || exit 1
	echo "alias ${new_alias}" >> ~/.bashrc

	source_error=$(bash -x ~/.bashrc 2>/dev/null; echo $?)

	if [ "${source_error}" -eq 0 ]; then
		echo "Alias ${new_alias} successfully added"
		rm -f ~/.bashrc-bck_malias-add-"${alias_name}"-"$(date +"%d-%m-%Y")" && echo "Backup of the .bashrc file deleted"
		exec bash
	else
		echo -e >&2 "\nERROR: An error occured when applying your alias\nPlease verify that you typed your alias correctly\nAlso, be aware that your alias name cannot contain space(s). However, it can contain \"-\" (hyphen) or \"_\" (underscore)"
		mv -f ~/.bashrc-bck_malias-add-"${alias_name}"-"$(date +"%d-%m-%Y")" ~/.bashrc && echo "Backup of the .bashrc file restored" || echo -e >&2 "\nERROR: An error occurred when restoring the backup of your ~/.bashrc file\nPlease, check for potential errors in it"
		exit 1
	fi
}

#Definition of the list function: Print the list of current aliases
list() {
	alias_list=$(grep -w "^alias" ~/.bashrc | awk '{$1=""}1' | sed "s/ //")
		
	echo -e "Alias list :\n"
	i=1
	while IFS= read -r line; do
	        echo "${i} - ${line}"
		((i=i+1))
	done < <(printf '%s\n' "${alias_list}")
}

#Definition of the delete function: Delete an alias (meant to be used in combination with the list function)
delete() {
	list

	read -rp $'\nPlease, type the number associated to the alias you want to remove: ' alias_selected

	alias_number=$(grep -wc "^alias" ~/.bashrc)

	if [ "${alias_selected}" -le "${alias_number}" ] && [ "${alias_selected}" -gt "0" ]; then
		alias_delete=$(sed -n "${alias_selected}"p <<< "${alias_list}")
		alias_name=$(echo "${alias_delete}" | cut -f1 -d"=")
		echo -e "\nThe following alias will be deleted: ${alias_delete}"
		read -rp $'Do you confirm? [y/N] ' answer

		case "${answer}" in
			[Yy])
				echo -e "\nDeleting the \"${alias_delete}\" alias"
			;;
			*)
				echo -e >&2 "\nAborting"
				exit 1
			;;
		esac

		cp -p ~/.bashrc ~/.bashrc-bck_malias-delete-"${alias_name}"-"$(date +"%d-%m-%Y")" && echo -e "\nBackup of the .bashrc file created" || exit 1
		sed -i "/^alias ${alias_delete}$/d" ~/.bashrc || exit 1

		source_error=$(bash -x ~/.bashrc 2>/dev/null; echo $?)

		if [ "${source_error}" = 0 ]; then
			echo -e "\nAlias ${alias_delete} successfully deleted" || exit 1
			rm -f ~/.bashrc-bck_malias-delete-"${alias_name}"-"$(date +"%d-%m-%Y")" && echo "Backup of the .bashrc file deleted"
			exec bash
		else
			echo -e >&2 "\nERROR: An error occured when deleting the alias"
			mv -f ~/.bashrc-bck_malias-delete-"${alias_name}"-"$(date +"%d-%m-%Y")" ~/.bashrc && echo "Backup of the .bashrc file restored" || echo -e >&2 "ERROR: A error occurred when restoring the backup of your ~/.bashrc file\nPlease, check for potential errors in it"
			exit 1
		fi
	else
		echo -e >&2 "\nError : Invalid input\nPlease, make sure you typed the correct number associated to the alias you want to delete"
		exit 1
	fi
}

#Execute the different functions depending on the selected argument
case "${argument}" in
	-m|--menu|"")
		menu
	;;&
	-a|--add)
		add
	;;
	-l|--list)
		list
	;;
	-d|--delete)
		delete
	;;
	-v|--version)
		version
	;;
	-h|--help)
		help
	;;
	*)
		invalid_argument
	;;
esac
