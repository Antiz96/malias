#!/bin/bash

#Clear the screen
clear >"$(tty)"

#Retrieve the current version from the "alias_manager.sh" script
current_version=$(grep -wm 1 "current_version" ~/.alias_manager/alias_manager.sh | cut -f2 -d"=" | sed "s/\"//g")

#Just a quick summary of how this program works and various information
echo "Description : alias_manager is a program that helps you manage your aliases"
echo "Author : Robin Candau"
echo "Links : https://rc-linux.com/ - https://github.com/Antiz96 - https://www.linkedin.com/in/robin-candau-3083a2173/"
echo -e "\n\"Alias manager\" is a collection of bash scripts that will help you manage your aliases"
echo -e "It will guide you through the process of adding, removing and listing your aliases by automate each operations for you\n"
echo "Basically, it will edit your .bashrc file and add or remove aliases for you (depending on what you asked for)"
echo -e "The .bashrc file is resourced after each operations for an immediate application, this way you do not need to logoff/logon to use your new aliases\n"
echo "A backup of your .bashrc file is created under your home directory before each operations"
echo -e "It is deleted or restored depending on the success of the current operation\n"
echo -e "If you want to learn more about the Alias Manager program, visit this link : https://github.com/Antiz96/alias_manager\n"
echo "You can read the changelog of each versions of the Alias Manager program by following this link : https://github.com/Antiz96/alias_manager#changelog"
echo "You're currently running the \"$current_version\" version"
