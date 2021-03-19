#!/bin/bash

###################################################################################################################
#Description : alias_manager is a program that helps you manage your aliases                               	  #
#Author : Robin Candau                                                                                            #
#Links : https://rc-linux.com/ - https://github.com/Antiz96 - https://www.linkedin.com/in/robin-candau-3083a2173/ #
###################################################################################################################

#Var that determines the current version of the Alias Manager program (used in the "update" section to check if the program is up to date or not)
current_version="V1.2.1"

#Var that determines whether if the program is going to relaunch or not. The entire program is encapsulated into a "while" loop determined by this var.
redo="a"

while [ "$redo" = "a" ]; do

  #Clear the screen
  clear >$(tty)

  echo "##################################################################################"
  echo "#                      Hello ! Welcome to the alias manager                      #"
  echo "##################################################################################"
  echo ""
  echo "Please, type one of the following : "
  echo "add           (adding an alias)"
  echo "remove        (removing an alias)"
  echo "list          (list all your current aliases)"
  echo "update        (check for available update and apply them)"
  echo "uninstall     (uninstall the Alias Manager program)"
  echo "readme        (display some information about the Alias Manager program)"
  echo "exit          (quit the Alias Manager program)"
  echo ""
  echo "Please, consider running \"update\" from time to time, to make sure you're using the latest version of the Alias Manager program"
  echo ""
  read -p "What do you want to do ? : " operation
  echo ""

  case "$operation" in
    add|Add|ADD )
                  clear >$(tty)

                  read -p "Please, type the alias name you want to add : " name_alias
                  read -p "Please, type the command you want to associate your alias name with : " command_alias
                  echo ""

                  #Transform the user input in the right format
                  new_alias="$name_alias"=\'"$command_alias"\'
                  echo "The following alias will be added : "$new_alias""
                  read -n 1 -r -s -p $'Press enter to continue, or ctrl + c to abort...\n'
                  echo ""

                  #Creates a backup of .bashrc file, adds the new alias to the .bashrc file and checks for potential errors
                  cp -p ~/.bashrc ~/.bashrc-bck-alias_manager-`date +"%d-%m-%Y"` && echo "Backup of .bashrc file created"
                  echo "alias" "$new_alias" >> ~/.bashrc
                  source_error=$(source ~/.bashrc 2>/dev/null; echo $?)

                  #If there's no error, tells the user that the alias has been added successfully and delete the backup of .bashrc file. Then, asks if the user wants to quit the program or relaunch it to do another action.
                  if [ "$source_error" = 0 ]; then
                    source ~/.bashrc && echo "Alias "$new_alias" successfully added"
                    echo ""
                    rm -f ~/.bashrc-bck-alias_manager-`date +"%d-%m-%Y"` && echo "Backup of .bashrc file deleted"
                    echo ""
                    read -p "Do you wish to do another operation ? (yes/no) : " answer
                    case "$answer" in
                      y|Y|yes|Yes|YES )
                                        echo ""
                                        echo "Program is relaunching"
                      ;;
                      n|N|no|No|NO )
                                      echo ""
                                      echo "Goodbye !"
                                      #Get out of the while loop
                                      redo="x"
                      ;;
                      * )
                          echo ""
                          echo "Error, the program expected \"yes\" or \"no\""
                          echo "Program is shutting down"
                          redo="x"
                      ;;
                    esac

                  #If there's an error, prints the error to the user and restores the backup file. Then, asks if the user wants to quit the program or relaunch it to do another action.
                  else
                    echo ""
                    echo "An error has occurred"
                    echo ""
                    echo "Please verify that your alias is correct and respects the following format : alias_name='command'"
                    echo "Also, be aware that your alias name cannot contain spaces. However, it can contain \"-\" or \"_\""
                    echo ""
                    rm -f ~/.bashrc && mv ~/.bashrc-bck-alias_manager-`date +"%d-%m-%Y"` ~/.bashrc && echo "Backup of .bashrc file restored"
                    echo ""
                    read -p "Do you wish to do another operation ? (yes/no) : " answer
                    case "$answer" in
                      y|Y|yes|Yes|YES )
                                        echo ""
                                        echo "Program is relaunching"
                      ;;
                      n|N|no|No|NO )
                                      echo ""
                                      echo "Goodbye !"
                                      redo="x"
                      ;;
                      * )
                          echo ""
                          echo "Error, the program expected \"yes\" or \"no\""
                          echo "Program is shutting down"
                          redo="x"
                      ;;
                    esac
                  fi
    ;;
    remove|Remove|REMOVE )
                           clear >$(tty)

                           #Just a quick disclaimer with an interessting "Press enter to continue" code at the end
                           echo "##########################################################################################################################################"
                           echo "#                                                        DISCLAIMER                                                                      #"
                           echo "##########################################################################################################################################"
                           echo "Please, be careful when using the \"remove\" function"
                           echo "Be aware that some aliases may be automatically created by the system itself for internal operations"
                           echo "I advise you to only remove aliases you created yourself (or only if you know their purposes)"
                           echo "Also, the \"alias_manager\" specific alias is voluntarily not shown here so you can't remove it through this program (which could break it)"
                           echo "If you want to remove the \"alias_manager\" alias anyway, you can do so by uninstalling the program"
                           echo ""
                           #https://www.tweaking4all.com/software/linux-software/bash-press-any-key/
                           read -n 1 -r -s -p $'Press enter to continue, or ctrl + c to abort...\n'
                           echo ""

                           #Puts the aliases list in a temporary file, excluding the "alias_manager" alias, so the user can't delete it (otherwise this program won't work anymore by simply typing the "alias_manager" command)
                           alias | grep -v "alias alias_manager='source ~/.alias_manager/alias_manager.sh'" > ~/.alias_list.txt

                           #Prints the aliases list with a unique number in front of each aliases, so the user can select the alias to delete by simply typing its associated number
                           echo "Aliases list :"
                           echo ""
                           alias_number=$(wc -l ~/.alias_list.txt | awk '{print $1}')
                           i=1
                           until [ "$i" -gt "$alias_number" ]; do
                             echo "$i - `sed -n "$i"p ~/.alias_list.txt`"
                             ((i=i+1))
                           done
                           echo ""
                           read -p "Please, select the number associated to the alias you want to remove : " alias_selected
                           echo ""

                           #If the number selected by the user is correct, creates a backup of .bashrc file and deletes the associated alias + unalias the alias.
                           if [ "$alias_selected" -le "$alias_number" ] && [ "$alias_selected" -gt "0" ]; then
                             echo ""

                             #Retrieve the alias associated to the number inputted by the user in the right patterns
                             alias_remove=$(sed -n "$alias_selected"p ~/.alias_list.txt | cut -f1- | sed 's/[^ ]* //')
                             alias_unalias=$(sed -n "$alias_selected"p ~/.alias_list.txt | cut -f1- | sed 's/[^ ]* //' | cut -f1 -d"=")
                             echo "The following alias will be removed : "$alias_remove""
			     read -n 1 -r -s -p $'Press enter to continue, or ctrl + c to abort...\n'
			     echo ""
                             cp -p ~/.bashrc ~/.bashrc-bck-alias_manager-`date +"%d-%m-%Y"` && echo "Backup of .bashrc file created"

                             #Removing alias
                             unalias_error=$(unalias "$alias_unalias" 2>/dev/null; echo $?)
                             grep -Eiv "$alias_remove" ~/.bashrc > ~/.bashrc-new-alias_manager-`date +"%d-%m-%Y"` && rm -f ~/.bashrc && mv ~/.bashrc-new-alias_manager-`date +"%d-%m-%Y"` ~/.bashrc
                             source_error=$(source ~/.bashrc 2>/dev/null; echo $?)

                             #If there's no error, removes the alias, deletes the .bashrc backup file and deletes the temporary file containing the aliases list. Then, asks the user if he wants to relaunch the program or not.
                             if [ "$unalias_error" = 0 ] && [ "$source_error" = 0 ]; then
                               unalias "$alias_unalias" && echo "unalias successful"
                               source ~/.bashrc && echo "alias successfully removed"
                               echo ""
                               rm -f ~/.bashrc-bck-alias_manager-`date +"%d-%m-%Y"` && echo "Backup of .bashrc file deleted"
                               rm -f ~/.alias_list.txt
                               echo ""
                               read -p "Do you wish to do another operation ? (yes/no) : " answer
                               case "$answer" in
                                 y|Y|yes|Yes|YES )
                                                   echo ""
                                                   echo "Program is relaunching"
                                 ;;
                                 n|N|no|No|NO )
                                                 echo ""
                                                 echo "Goodbye !"
                                                 redo="x"
                                 ;;
                                 * )
                                     echo ""
                                     echo "Error, the program expected \"yes\" or \"no\""
                                     echo "Program is shutting down"
                                     redo="x"
                                 ;;
                               esac

                             #If there's an error, prints the error to the user and restores the backup file. Then, asks if the user wants to quit the program or relaunch it to do another action.
                             else
                               echo ""
                               echo "An error has occurred : "
                               unalias "$alias_unalias"
                               source ~/.bashrc
                               echo ""
                               rm -f ~/.bashrc && mv ~/.bashrc-bck-alias_manager-`date +"%d-%m-%Y"` ~/.bashrc && echo "Backup of .bashrc file restored"
                               rm -f ~/.alias_list.txt
                               echo ""
                               read -p "Do you wish to do another operation ? (yes/no) : " answer
                               case "$answer" in
                                 y|Y|yes|Yes|YES )
                                                   echo ""
                                                   echo "Program is relaunching"
                                 ;;
                                 n|N|no|No|NO )
                                                 echo ""
                                                 echo "Goodbye !"
                                                 redo="x"
                                 ;;
                                 * )
                                     echo ""
                                     echo "Error, the program expected \"yes\" or \"no\""
                                     echo "Program is shutting down"
                                     redo="x"
                                 ;;
                               esac
                             fi
                           else
                            echo "Error : Invalid input"
                            echo ""
                            echo "Please, select the number associated to the alias you want to remove"
                            echo ""
                            echo "The \"remove\" operation has been aborted"
                            echo "The Alias Manager program will relaunch automatically in a few seconds"
                            rm -f ~/.alias_list.txt
                            sleep 15
                           fi
    ;;
    list|List|LIST )
                     clear >$(tty)

                     #This is basically the exact same code block used in the "list" part of the "remove" function, except that the "alias_manager" specific alias is not excluded this time
                     alias > ~/.alias_list.txt
                     echo "Aliases list :"
                     echo""
                     alias_number=$(wc -l ~/.alias_list.txt | awk '{print $1}')
                     i=1
                     until [ "$i" -gt "$alias_number" ]; do
                       echo "$i - `sed -n "$i"p ~/.alias_list.txt`"
                       ((i=i+1))
                     done
                     rm -f ~/.alias_list.txt
                     echo ""
                     read -p "Do you wish to do another operation ? (yes/no) : " answer
                     case "$answer" in
                       y|Y|yes|Yes|YES )
                                         echo ""
                                         echo "Program is relaunching"
                       ;;
                       n|N|no|No|NO )
                                       echo ""
                                       echo "Goodbye !"
                                       redo="x"
                       ;;
                       * )
                           echo ""
                           echo "Error, the program expected \"yes\" or \"no\""
                           echo "Program is shutting down"
                           redo="x"
                       ;;
                     esac
    ;;
    update|Update|UPDATE )
                     clear >$(tty)
		     
		     echo "Please, make sure you are connected to the internet and curl is installed on your machine"
		     read -n 1 -r -s -p $'Press enter to continue, or ctrl + c to abort...\n'
		     echo ""

                     #Var that determines the latest version available for the program (used to check if the program is up to date or not)
		     get_latest_version=$(curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/latest_release.txt | grep "V" | wc -l)
                     latest_version=$(curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/latest_release.txt)

		     if [ "$get_latest_version" = 1 ]; then
		       echo "You're current version is "$current_version""
	  	       echo "The latest version available is "$latest_version""
  		       echo ""

		       if [ "$current_version" != "$latest_version" ]; then
                         echo "A new update is available"
		         read -n 1 -r -s -p $'Press enter to install it, or ctrl + c to abort...\n'
		         echo ""
		         ~/.alias_manager/update_alias_manager.sh
		         redo="x"
		       else
		         echo "You're running the latest version of the Alias Manager program :)"
			 echo ""
                         read -p "Do you wish to do another operation ? (yes/no) : " answer
                         case "$answer" in
                           y|Y|yes|Yes|YES )
                                             echo ""
                                             echo "Program is relaunching"
                           ;;
                           n|N|no|No|NO )
                                           echo ""
                                           echo "Goodbye !"
                                           redo="x"
                           ;;
                           * )
                               echo ""
                               echo "Error, the program expected \"yes\" or \"no\""
                               echo "Program is shutting down"
                               redo="x"
                           ;;
                         esac
		       fi
		     else
		       echo "It looks like you're not connected to the internet (or you don't have access to github)" 
		       echo "Please, make sure you're connected to the internet and curl is installed on your machine, then try again"
		       echo ""
		       echo "The Alias Manager program will automatically relaunch in a few seconds"
		       sleep 15
		     fi
    ;;
    uninstall|Uninstall|UNINSTALL )
	    	     clear >$(tty)

		     echo "You're about to uninstall the Alias Manager program"
		     read -n 1 -r -s -p $'Press enter to continue, or ctrl + c to abort...\n'
		     echo ""

		     source ~/.alias_manager/uninstall_alias_manager.sh
		     redo="x"
    ;;
    readme|Readme|README )
                           clear >$(tty)

                           #Just a quick summary of how this program works and various information
                           echo "###################################################################################################################"
                           echo "#Description : alias_manager is a program that helps you manage your aliases 	                                   #"
                           echo "#Author : Robin Candau                                                                                            #"
                           echo "#Links : https://rc-linux.com/ - https://github.com/Antiz96 - https://www.linkedin.com/in/robin-candau-3083a2173/ #"
                           echo "###################################################################################################################"
                           echo ""
                           echo "\"Alias manager\" is a bash script that will manage your aliases for you"
                           echo "It will guide you through the process of adding and removing aliases and will automatise each operations for you"
                           echo ""
                           echo "Basically, it will edit your .bashrc file and add or remove aliases for you (depending on what you asked for)"
                           echo "The .bashrc file is resourced after each operation for an immediate application, this way you do not need to reboot or logoff/logon to use your new aliases"
                           echo ""
                           echo "A backup of your .bashrc file is created under your home directory before each operations"
                           echo "It is deleted or restored depending on the success of each operations"
                           echo ""
                           echo "If you want to learn more about this program, please visit this link : https://github.com/Antiz96/alias_manager"
			   echo ""
			   echo "You're current version is "$current_version""
			   echo "Consider running \"update\" to check if you're using the last version of the Alias Manager program"
                           echo ""
			   echo ""
                           read -p "Do you wish to do another operation ? (yes/no) : " answer
                           case "$answer" in
                             y|Y|yes|Yes|YES )
                                               echo ""
                                               echo "Program is relaunching"
                             ;;
                             n|N|no|No|NO )
                                             echo ""
                                             echo "Goodbye !"
                                             redo="x"
                             ;;
                             * )
                                 echo ""
                                 echo "Error, the program expected \"yes\" or \"no\""
                                 echo "Program is shutting down"
                                 redo="x"
                             ;;
                           esac
    ;;
    exit|Exit|EXIT )
                     #Just quitting the program
                     echo "Goodbye !"
                     redo="x"
    ;;
    * )
       clear >$(tty)

       #Relaunching the program
       echo "Error : Invalid input"
       echo "The Alias Manager program will relaunch automatically in a few seconds"
       sleep 10
    ;;
  esac
done
