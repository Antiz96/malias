#!/bin/bash

echo ""
mkdir ~/.alias_manager && echo "Alias manager directory successfully created"

curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/alias_manager.sh --output alias_manager.sh && mv alias_manager.sh ~/.alias_manager/ && echo "Alias manager program successfully downloaded"

curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/update_alias_manager.sh --output update_alias_manager.sh && mv update_alias_manager.sh ~/.alias_manager/ && echo "Update script successfully downloaded"

curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/uninstall_alias_manager.sh --output uninstall_alias_manager.sh && mv uninstall_alias_manager.sh ~/.alias_manager/ && echo "Uninstallation script successfully downloaded"

chmod +x ~/.alias_manager/*.sh && echo "Alias manager program succesfully configured"

echo "alias alias_manager="source ~/.alias_manager/alias_manager.sh"" >> ~/.bashrc && source ~/.bashrc && echo "Specific alias successfully created"

rm -f install_alias_manager.sh

echo ""
echo "The Alias Manager program is now ready to be used"
echo "You can launch it by typing the following command : alias_manager"
echo ""
echo "If you want to learn more about the Alias Manager program, please visit this link : https://github.com/Antiz96/alias_manager"
echo ""
echo "Thank you for downloading Alias Manager :)"
