#!/bin/bash

pkgname="Malias"
_pkgname="malias"
url="https://github.com/Antiz96/Malias"

sudo rm -f /usr/local/bin/"$_pkgname"
sudo rm -f /usr/local/share/man/man1/"$_pkgname".1.gz

echo -e "$pkgname has been successfully uninstalled\nPlease, visit $url for more information"
