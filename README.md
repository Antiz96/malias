# Malias

An alias manager that allows you to easily add, delete or list your bash aliases.

## Table of contents
* [Description](#description)
* [Dependencies](#dependencies)
* [Installation](#installation)
* [Usage](#usage)
* [Documentation](#documentation)
* [Contributing](#contributing)

## Description

An alias manager that allows you to easily add, delete or list your bash aliases in your ".bashrc" file by automating and securing every steps for you.

## Dependencies

The [make](https://www.gnu.org/software/make/) package is necessary to install/uninstall `malias`, install it via your package manager if needed.

## Installation

### AUR

Arch (or Arch based distro) users can install the [malias](https://aur.archlinux.org/packages/malias "malias AUR package") AUR package.

### From Source

Download the archive of the [latest stable release](https://github.com/Antiz96/malias/releases/latest) and extract it.  
*Alternatively, you can clone this repository via `git`.*  
  
To install `malias`, go into the extracted/cloned directory and run the following command:  
```
sudo make install
```
   
To uninstall `malias`, go into the extracted/cloned directory and run the following command:  
```
sudo make uninstall
```

## Usage

### The main menu

Run the `malias` command to open the main menu that will print every possible operations (`add`, `list`, `delete`, `help`, `quit`) followed by a short description.  
From there, just type the the operation (or simply the first letter) you want to perform.  

### The add operation

The `add` operation allows you to add a new alias.   
It will ask for the **alias name** and the **command** you want to associate it with.  
For instance, in the alias `ll='ls -l'`, **ll** would be the **alias name** and **ls -l** would be the **command**.  
After filling in the requested information and giving the confirmation to proceed, the new alias will automatically be added to your .bashrc file (after being backuped).  
Malias will then look for potential errors and apply the new alias or restore the .bashrc's backup (in case there's errors).

### The list operation
  
The `list` operation prints the list of your current aliases.  

### The delete operation  

The `delete` operation allows you to delete an alias.   
It will print the list of your current aliases with a **unique number** in front of each aliases (like the `list` function does).  
You must then type the number associated to the alias you want to delete and give the confirmation to proceed.  
Once done, the selected alias will automatically be removed from your .bashrc file (after being backuped).  
Malias will then look for potential errors and apply the deletion or restore the .bashrc's backup (in case there's errors).  
  
Check the screenshots below for more information.

### Screenshot

Run the `malias` command to open the main menu (also accessible with `malias --menu` or `malias -m`).  
  
You can then type `add` (`a` for short) to add a new alias, `list` (`l` for short) to list your current aliases, `delete` (`d` for short) to delete an alias, `help` (`h` for short) to display the help or `quit` (`q` for short) to quit :
![Malias-Menu](https://user-images.githubusercontent.com/53110319/166229747-45705537-e3ac-413c-9d3d-ba3d0a541a83.png)  
  
*Alternatively, you can run the following commands to launch the associated function directly:*  
`malias --add` or `malias -a` to add an alias.  
`malias --list` or `malias -l` to list your current aliases.  
`malias --delete` or `malias -d` to delete an alias.  
`malias --help` or `malias -h` to display the help.  
    
To add an alias, type its name and then the command you want to associate it with.  
The new alias can then be used right away.  
Each step is automated and secured for you (with backup of your .bashrc file, error checking, backup restore if needed, etc...).  
Example below with the alias `list='ls -ltr'`, where **list** is the alias name and **ls -ltr** the command:
![Malias-Add](https://user-images.githubusercontent.com/53110319/166231323-42a1a89d-3bc5-4cd3-93a0-abe16b5c1def.png)  
  
The `list` function is self explanatory, it basically prints your current aliases like so:
![Malias-List](https://user-images.githubusercontent.com/53110319/166232292-aa5b2d15-683d-4535-ab07-576bfb6c05cf.png)  
  
To delete an alias, type the number associated to the alias you want to delete.  
The deleted alias will then be gone right away.  
Once again, each step is automated and secured for you (with backup of your .bashrc file, error checking, backup restore if needed, etc...)    
Example below with the 31st alias (`list='ls -ltr'`), previously added in the "add" function example :
![Malias-Delete](https://user-images.githubusercontent.com/53110319/166232379-be5b619e-2d8f-4d09-8f71-c87c9a43e550.png)

## Documentation

```
Options:  
  -m, --menu     Print a menu that lists possible operations to choose from (default operation)  
  -a, --add      Add a new alias  
  -l, --list     List all current aliases  
  -d, --delete   Delete an existing alias  
  -h, --help     Display this message and exit  
  -V, --version  Display version information and exit  
  
For more information, see the malias(1) man page
```

## Contributing

You can raise your issues, feedbacks and suggestions in the [issues tab](https://github.com/Antiz96/malias/issues).  
[Pull requests](https://github.com/Antiz96/malias/pulls) are welcomed as well!
