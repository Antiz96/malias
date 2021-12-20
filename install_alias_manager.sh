#!/bin/bash

#Create the Alias Manager's working directory
mkdir -p ~/.alias_manager && echo -e "\nAlias manager's working directory successfully created" || exit 1

#Download all the scripts
curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/alias_manager.sh -o ~/.alias_manager/alias_manager.sh && echo "Main menu script successfully downloaded" || exit 1
curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/add_alias_manager.sh -o ~/.alias_manager/add_alias_manager.sh && echo "\"Add\" function script successfully downloaded" || exit 1
curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/remove_alias_manager.sh -o ~/.alias_manager/remove_alias_manager.sh && echo "\"Remove\" function script successfully downloaded" || exit 1
curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/list_alias_manager.sh -o ~/.alias_manager/list_alias_manager.sh && echo "\"List\" function script successfully downloaded" || exit 1
curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/update_alias_manager.sh -o ~/.alias_manager/update_alias_manager.sh && echo "\"Update\" function script successfully downloaded" || exit 1
curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/uninstall_alias_manager.sh -o ~/.alias_manager/uninstall_alias_manager.sh && echo "\"Uninstall\" function script successfully downloaded" || exit 1
curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/readme_alias_manager.sh -o ~/.alias_manager/readme_alias_manager.sh && echo "\"Readme\" function script successfully downloaded" || exit 1

#Make all the scripts executable
chmod +x ~/.alias_manager/*.sh && echo "Execution permission succesfully applied" || exit 1

#Create the "alias_manager" alias to launch the program
echo "alias alias_manager='source ~/.alias_manager/alias_manager.sh'" >> ~/.bashrc && source ~/.bashrc && echo "Alias Manager successfully configured" || exit 1

#Echo "Succesfully installed" + giving some info to the user
echo -e "\nThe Alias Manager program is now ready to be used\nYou can launch it by typing the following command : \"alias_manager\"\n\nIf you want to learn more about the Alias Manager program, please visit this link : https://github.com/Antiz96/alias_manager\nThank you for downloading \"Alias Manager\" :)"

#Move the install script to the Alias Manager's working directory
mv -f install_alias_manager.sh ~/.alias_manager/
