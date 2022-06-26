#!/bin/bash

pkgname="Malias"
_pkgname="malias"
url="https://github.com/Antiz96/Malias"

echo -e "$pkgname is going to be uninstalled\n"

sudo rm -f /usr/local/bin/"$_pkgname" || exit 1
sudo rm -f /usr/local/share/man/man1/"$_pkgname".1.gz || exit 1

echo -e "$pkgname has been successfully uninstalled\nPlease, visit $url for more information"
