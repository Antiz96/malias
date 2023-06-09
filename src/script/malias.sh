#!/bin/bash

# malias: An alias manager that allows you to easily add, delete or list your bash aliases in your ".bashrc" file by automating and securing every steps for you.
# https://github.com/Antiz96/malias
# Licensed under the GPL-3.0 license

# Variables definition
name="malias"
version="1.2.4"
option="${1}"

# Definition of the help function: Print the help message
help() {
	cat <<EOF
${name} v${version}

An alias manager that allows you to easily add, delete or list your bash aliases in your ".bashrc" file by automating and securing every steps for you.

Options:
  -m, --menu     Print a menu that lists possible operations to choose from (default operation)
  -a, --add      Add a new alias
  -l, --list     List all current aliases
  -d, --delete   Delete an existing alias
  -h, --help     Display this message and exit
  -V, --version  Display version information and exit

For more information, see the ${name}(1) man page
EOF
}

# Definition of the version function: Print the current version
version() {
	echo "${name} ${version}"
}

# Definition of the invalid_option function: Print an error message, ask the user to check the help and exit
invalid_option() {
	echo -e >&2 "${name}: invalid option -- '${option}'\nTry '${name} --help' for more information."
	exit 1
}

# Definition of the backup_bashrc function: Create a backup of the .bashrc file (used in the "add" and "delete" function)
backup_bashrc() {
	if cp -p ~/.bashrc ~/".bashrc-bck_${name}-${operation}-${alias_name}"; then
		echo -e "\nBackup of the .bashrc file created"
	else
		echo -e >&2 "\nERROR: An error occured when creating the backup of the .bashrc file"
		exit 3
	fi
}

# Definition of the check_bashrc_error function: Check for potential errors after adding or removing an alias and restore the backup of the .bashrc file if needed (used in the "add" and "delete" function)
check_bashrc_error() {
	source_error=$(bash -x ~/.bashrc 2>/dev/null; echo $?)

	if [ "${source_error}" -eq 0 ]; then
		case "${operation}" in
			add)
				echo -e "\nAlias ${new_alias} successfully added"
			;;
			delete)
				echo -e "\nAlias ${alias_delete} successfully deleted"
			;;
		esac

		rm -f ~/".bashrc-bck_${name}-${operation}-${alias_name}"
		echo "Backup of the .bashrc file deleted"
		exec bash
	else
		case "${operation}" in
			add)
				echo -e >&2 "\nERROR: An error occured when adding the alias\nPlease verify that you typed the alias correctly\nAlso, be aware that the alias name cannot contain space(s). However, it can contain \"-\" (hyphen) or \"_\" (underscore)"
			;;
			delete)
				echo -e >&2 "\nERROR: An error occured when deleting the alias"
			;;
		esac

		if mv -f ~/".bashrc-bck_${name}-${operation}-${alias_name}" ~/.bashrc; then
			echo "Backup of the .bashrc file restored"
		else
			echo -e >&2 "ERROR: An error occurred when restoring the backup of the ~/.bashrc file\nPlease, check for potential errors in it"
			exit 3
		fi
		exit 4
	fi
}

# Definition of the menu function: Print a menu that lists possible operations to choose from
menu() {
	clear >"$(tty)"

	cat <<EOF
Welcome to Malias!

Please, type one of the following operations:

add     (Add a new alias)
list    (List all current aliases)
delete  (Delete an existing alias)
help    (Print the help)
quit    (Quit Malias)
EOF

	read -rp $'\nWhat operation do you want to do? ' option
	option=$(echo "${option}" | awk '{print tolower($0)}')

	case "${option}" in
		a|add)
			option="--add"
		;;
		l|list)
			option="--list"
		;;
		d|delete)
			option="--delete"
		;;
		h|help)
			option="--help"
		;;
		q|quit)
			echo -e "\nGoodbye !"
			exit 0
		;;
		*)
			invalid_option
		;;
	esac

	echo
}

# Definition of the add function: Add a new alias
add() {
	operation="add"

	read -rp "Please, type the alias name you want to add: " alias_name
	read -rp "Please, type the command you want to associate the alias with: " alias_command

	new_alias="${alias_name}"=\'"${alias_command}"\'
	echo -e "\nThe following alias will be added: ${new_alias}"
	read -rp $'Do you confirm? [Y/n] ' answer

	case "${answer}" in
		[Yy]|"")
			echo -e "\nAdding the \"${new_alias}\" alias"
		;;
		*)
			echo -e >&2 "\nAborting"
			exit 2
		;;
	esac

	backup_bashrc

	echo "alias ${new_alias}" >> ~/.bashrc

	check_bashrc_error
}

# Definition of the list function: Print the list of current aliases (also used in the "delete" function)
list() {
	alias_list=$(grep -w "^alias" ~/.bashrc | awk '{$1=""}1' | sed "s/ //")
		
	echo -e "Alias list :\n"
	i=1
	while IFS= read -r line; do
	        echo "${i} - ${line}"
		((i=i+1))
	done < <(printf '%s\n' "${alias_list}")
}

# Definition of the delete function: Delete an alias
delete() {
	operation="delete"

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
				exit 2
			;;
		esac

		backup_bashrc

		sed -i "/^alias ${alias_delete}$/d" ~/.bashrc

		check_bashrc_error
	else
		echo -e >&2 "\nError : Invalid input\nPlease, make sure you typed the correct number associated to the alias you want to delete"
		exit 1
	fi
}

# Execute the different functions depending on the option
case "${option}" in
	-m|--menu|"")
		menu
	;;
esac

case "${option}" in
	-a|--add)
		add
	;;
	-l|--list)
		list
	;;
	-d|--delete)
		delete
	;;
	-h|--help)
		help
	;;
	-V|--version)
		version
	;;
	*)
		invalid_option
	;;
esac
