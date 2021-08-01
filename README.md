# Alias Manager

alias_manager is a program that helps you manage your aliases

This program has been deeply tested (with unit tests) on Ubuntu (20.04), Debian (10), Fedora (32), CentOS (8) and Arch Linux

## Table of contents
* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)
* [Update](#update)
* [Uninstallation](#uninstallation)
* [Releases](#releases)
* [Technologies](#technologies)


## Description

"Alias manager" is a bash script that will manage your aliases for you

It will guide you through the process of adding and removing aliases and will automatise each operations for you

Basically, it will edit your .bashrc file and add or remove aliases for you (depending on what you asked for)

The .bashrc file is resourced after each operation for an immediate application, this way you do not need to reboot or logoff/logon to use your new aliases

A backup of your .bashrc file is created under your home directory before each operations

It is deleted or restored depending on the success of each operations


## Installation

Copy/paste the following command in your terminal :

`curl -s https://raw.githubusercontent.com/Antiz96/alias_manager/master/install_alias_manager.sh --output install_alias_manager.sh && chmod +x install_alias_manager.sh && source install_alias_manager.sh`

(requires an internet connection and "curl" installed on your machine)


## Usage

To launch the Alias Manager program, just type the following command : 

`alias_manager`

Once the program has started, type one of the following options :

Option    |  Action
-------   |  ------
add       |  adding an alias
remove    |  removing an alias
list      |  list all your current aliases
update    |  check for available update and apply them
uninstall |  uninstall the Alias Manager program
readme    |  display some information about the Alias Manager program
exit      |  quit the Alias Manager program


## Update

To update the Alias Manager program, launch it by typing the following command :

`alias_manager`

Once the program has started, type :

`update`

(requires an internet connection and "curl" installed on your machine)


## Uninstallation

To uninstall the Alias Manager program, launch it by typing the following command :

`alias_manager`

Once the program has started, type :

`uninstall`

All aliases added through the Alias Manager program will be keepeed. Don't forget to remove them via the Alias Manager program before the uninstallation if you don't want to keep them


## Releases

Version  | What's new ?
-------- | ------------
V1.0     | Initial release
V1.0.1   | The Alias Manager directory is now hidden (~/.alias_manager)
V1.0.2   | The Alias Manager program now asks for a confirmation before removing the selected alias through the "remove" option + various improvements
V1.1     | Creation of automated scripts for update and uninstallation
V1.2     | Added options to update and uninstall the Alias Manager program directly within the main "menu" (recommended usage as of now)
V1.2.1   | The Alias Manager program now asks for a confirmation before adding an alias through the "add" option

## Technologies

The Alias Manager program has been entirely written with bash (Version 5.1.4)

The automated installation and updates require an internet connection and "curl" installed on your machine 

