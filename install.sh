#!/bin/bash

latest_release=$(curl -s https://raw.githubusercontent.com/Antiz96/Malias/main/latest_release.txt)

curl -Ls https://github.com/Antiz96/Malias/releases/download/v$latest_release/malias-$latest_release.tar.gz -o /tmp/malias-$latest_release.tar.gz || exit 1
mkdir -p /tmp/malias_src || exit 1
tar -xf /tmp/malias-$latest_release.tar.gz -C /tmp/malias_src/ || exit 1
chmod +x /tmp/malias_src/bin/*.sh || exit 1
sudo cp -f /tmp/malias_src/bin/malias.sh /usr/local/bin/malias || exit 1
sudo cp -f /tmp/malias_src/bin/malias-add.sh /usr/local/bin/malias-add || exit 1
sudo cp -f /tmp/malias_src/bin/malias-list.sh /usr/local/bin/malias-list || exit 1
sudo cp -f /tmp/malias_src/bin/malias-delete.sh /usr/local/bin/malias-delete || exit 1
sudo mkdir -p /usr/local/share/man/man1 || exit 1
sudo cp -f /tmp/malias_src/man/malias.1.gz /usr/local/share/man/man1/ || exit 1
rm -rf /tmp/malias_src/ /tmp/malias-$latest_release.tar.gz || exit 1

echo -e "Malias has been successfully installed\nPlease, check https://github.com/Antiz96/Malias for more information\n\nThanks for downloading !"
