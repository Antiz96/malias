# Alias Manager

"Alias Manager" is a program that helps you manage your aliases

**Important :**
*Since the release of the "2.0" version that came out in the end of December 2021, everyone that already had the Alias Manager program installed before this release (and thus still using a "1.X" version) will need to update it "manually" by typing the following command in their terminal :*
`curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/update_alias_manager.sh -o ~/.alias_manager/update_alias_manager.sh && chmod +x ~/.alias_manager/update_alias_manager.sh && source ~/.alias_manager/update_alias_manager.sh`
*Indeed, the big changes in the structure of the code brought by the "2.0" version make the automated update from version "1.X" to version "2.X" impossible
Performing an automated update through the main menu from a "1.X" version will now result in a error and will break the program
Don't worry tho, you only need to launch the above command to fix it by updating to the latest version
You'll then be able to perform automated updates through the main menu as before
I apologize for that extra step. Fortunately, the structure changes brought by the "2.0" version will prevent such problems for the future ! :)*

## Table of contents
* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)
* [Update](#update)
* [Uninstallation](#uninstallation)
* [Changelog](#changelog)
* [Technologies and prerequisites](#technologies-and-prerequisites)


## Description

"Alias Manager" is a collection of bash scripts that will help you manage your aliases

It will guide you through the process of adding, removing and listing your aliases by automate each operations for you

Basically, it will edit your .bashrc file and add or remove aliases for you (depending on what you asked for)

The .bashrc file is resourced after each operation for an immediate application, this way you do not need logoff/logon to use your new aliases

A backup of your .bashrc file is created under your home directory before each operations

It is deleted or restored depending on the success of each operations


## Installation

Copy/paste the following command in your terminal :

`curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/install_alias_manager.sh -O && chmod +x install_alias_manager.sh && source install_alias_manager.sh`

(requires an internet connection and "curl" installed on your machine)


## Usage

To launch the "Alias Manager" program, just type the following command : 

`alias_manager`

Once the program has started, type one of the following options :

Option    |  Action
-------   |  ------
add       |  Adding an alias
remove    |  Removing an alias
list      |  List all your current aliases
update    |  Update the Alias Manager program
uninstall |  Uninstall the Alias Manager program
readme    |  Display some information about the Alias Manager program
exit      |  Quit the Alias Manager program


## Update

To update the Alias Manager program, launch it by typing the following command :

`alias_manager`

Once the program has started, type :

`update`

(requires an internet connection and "curl" installed on your machine)

**Since the "2.1" version, there's an update checker that launch itself automatically each time you'll start the Alias Manager program
You'll now be notified on the main menu each time a new update is available**


## Uninstallation

To uninstall the Alias Manager program, launch it by typing the following command :

`alias_manager`

Once the program has started, type :

`uninstall`

All aliases added through the Alias Manager program will be keepeed. Don't forget to remove them before the uninstallation if you don't want them anymore


## Changelog

Version  | What's new ?
-------- | ------------
V1.0     | Initial release
V1.0.1   | The Alias Manager directory is now hidden (~/.alias_manager)
V1.0.2   | The Alias Manager program now asks for a confirmation before removing the selected alias through the "remove" option + various improvements
V1.1     | Creation of automated scripts for update and uninstallation
V1.2     | Added options to update and uninstall the Alias Manager program directly within the main "menu" (recommended usage as of now)
V1.2.1   | The Alias Manager program now asks for a confirmation before adding an alias through the "add" option
V2.0	 | Complete revision of the code and program structure to make them cleaner and more optimized
V2.1	 | Add an update auto-check at start of the program. The current version is now printed in the main menu


## Technologies and prerequisites

The Alias Manager program has been entirely written with bash

The automated installation and update require an internet connection and "curl" installed on your machine
