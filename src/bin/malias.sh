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
		malias-add
	;;
	#If the -l (or --list) option is passed to the "malias" command, execute the "malias-list" script
	-l|--list)
		malias-list
	;;
	#If the -d (or --delete) option is passed to the "malias" command, execute the "malias-delete" script
	-d|--delete)
		malias-delete
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
