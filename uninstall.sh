#!/bin/bash

sudo rm -f /usr/local/bin/malias || exit 1
sudo rm -f /usr/local/bin/malias-add || exit 1
sudo rm -f /usr/local/bin/malias-list || exit 1
sudo rm -f /usr/local/bin/malias-delete || exit 1
sudo rm -f /usr/local/share/man/man1/malias.1.gz || exit 1

echo "Malias has been successfully uninstalled"