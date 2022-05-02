# Malias

An  alias  manager that allows you to easily add, delete or list your bash aliases.

## Table of contents
* [Description](#description)
* [Installation](#installation)
* [Dependencies](#dependencies)
* [Usage](#usage)
* [Documentation](#documentation)
* [Tips and tricks](#tips-and-tricks)


## Description

An alias manager that allows you to easily add, delete or list your bash aliases in your ".bashrc" file by automating and securing every steps for you.

## Installation

### AUR

Arch (or Arch based distro) users can install the [malias](https://aur.archlinux.org/packages/malias "malias AUR package") AUR package.

### From Source

#### Installation

Launch the following command in your terminal to execute the install script (requires "curl" and "sudo") :
```
curl -s https://raw.githubusercontent.com/Antiz96/Malias/main/install.sh | bash
```

#### Update

Simply re-execute the install script (requires "curl" and "sudo") :
```
curl -s https://raw.githubusercontent.com/Antiz96/Malias/main/install.sh | bash
```

#### Uninstalling

Launch the following command in your terminal to execute the uninstall script :
```
curl -s https://raw.githubusercontent.com/Antiz96/Malias/main/uninstall.sh | bash
```

## Usage

### Wiki Usage Page

Refer to the [Wiki Usage Page](https://github.com/Antiz96/malias/wiki/Usage "Wiki Usage Page") and to the screenshots below for more information.

### Screenshot

Type the `malias` command to open the main menu (also accessible with `malias --menu` or `malias -m`).
<br>
You can then type **add** (**a** for short) to add a new alias, **list** (**l** for short) to list your current aliases, **delete** (**d** for short) to delete an alias, **help** (**h** for short) to display the help or **quit** (**q** for short) to quit :
![Malias-Menu](https://user-images.githubusercontent.com/53110319/166229747-45705537-e3ac-413c-9d3d-ba3d0a541a83.png)
<br>
<br>
*Alternatively, you can type the following commands to launch the associate function directly :*
`malias --add` or `malias -a` to add an alias.
`malias --list` or `malias -l` to list your current aliases.
`malias --delete` or `malias -d` to delete an alias.
`malias --help` or `malias -h` to display the help.
<br>
<br>
To add an alias, type its name and then the command you want to associate it with.
<br>
The new alias can directly be used right away.
<br>
Each step is automated and secure for you (with backup of your .bashrc file, error checking, backup restore if needed, etc...).
<br>
Example below with the alias **list='ls -ltr'**, where **list** is the alias name and **ls -ltr** the command :
![Malias-Add](https://user-images.githubusercontent.com/53110319/166231323-42a1a89d-3bc5-4cd3-93a0-abe16b5c1def.png)
<br>
<br>
The "list" function is pretty self explanatory, it basically prints your current aliases like so :
![Malias-List](https://user-images.githubusercontent.com/53110319/166232292-aa5b2d15-683d-4535-ab07-576bfb6c05cf.png)
<br>
<br>
To delete an alias, type the number associated to the alias you want to delete.
<br>
The deleted alias will be gone right away.
<br>
Once again, each step is automated and secure for you (with backup of your .bashrc file, error checking, backup restore if needed, etc...)
<br>
Example below with the 30th alias (list='ls -ltr'), previously added in the "add" function example :
![Malias-Delete](https://user-images.githubusercontent.com/53110319/166232379-be5b619e-2d8f-4d09-8f71-c87c9a43e550.png)


## Documentation

Refer to the [Wiki Documentation Page](https://github.com/Antiz96/malias/wiki/Documentation "Wiki Documentation Page").
<br>
<br>
The full documentation is also available as a man page and with the "--help" function.
<br>
Type `man malias` or `malias --help` after you've installed the **malias** package.
