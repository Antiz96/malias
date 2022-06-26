#!/bin/bash

pkgname="Malias"
_pkgname="malias"
url="https://github.com/Antiz96/Malias"
latest_release=$(curl -s https://raw.githubusercontent.com/Antiz96/Malias/main/latest_release.txt)

checksum=$(curl -Ls "$url"/releases/download/v"$latest_release"/sha256sum.txt)
installed=$(command -v "$_pkgname")
current_version=$("$_pkgname" -v)

package() {
	curl -Ls "$url"/archive/v"$latest_release".tar.gz -o /tmp/"$pkgname"-"$latest_release".tar.gz

	if ! echo "$checksum $pkgname-$latest_release.tar.gz" | sha256sum -c --status -; then
		echo -e >&2 "$pkgname's archive integrity check failed\nAborting\n\nPlease, verify that you have a working internet connexion and curl installed on your machine\nIf the problem persists anyway, you can open an issue at $url/issues"
		rm -f /tmp/"$pkgname"-"$latest_release".tar.gz
		exit 1
	else
		echo -e "$pkgname's archive integrity validated\nProceeding to installation..."
	fi

	tar -xf /tmp/"$pkgname"-"$latest_release".tar.gz
	chmod +x /tmp/"$pkgname"-"$latest_release"/src/bin/"$_pkgname".sh
	gzip /tmp/"$pkgname"-"$latest_release"/src/man/"$_pkgname".1
	sudo cp -f /tmp/"$pkgname"-"$latest_release"/src/bin/"$_pkgname".sh /usr/local/bin/"$_pkgname"
	sudo mkdir -p /usr/local/share/man/man1
	sudo cp -f /tmp/"$pkgname"-"$latest_release"/src/man/"$_pkgname".1.gz /usr/local/share/man/man1/
	rm -rf /tmp/"$pkgname"-"$latest_release" /tmp/"$pkgname"-"$latest_release".tar.gz
}

if [ -z "$installed" ]; then
	echo "$pkgname is going to be installed"
	read -rp $'Proceed with installation ? [Y/n] ' answer
	case "$answer" in
		[Yy]|"")
			package || { echo -e >&2 "An error occured during the installation\n\nPlease, verify that you have a working internet connexion and curl installed on your machine\nIf the problem persists anyway, you can open an issue at $url/issues" ; exit 1; }
			echo -e "\n$pkgname has been successfully installed\nPlease, visit $url for more information\n\nThanks for downloading !"
			exit 0
		;;
		*)
			exit 1
		;;
	esac
elif [ "$current_version" != "$latest_release" ]; then
	echo "A new update is available for $pkgname"
	read -rp $'Proceed with installation ? [Y/n] ' answer
	case "$answer" in
		[Yy]|"")
			package || { echo -e >&2 "An error occured during the installation\n\nPlease, verify that you have a working internet connexion and curl installed on your machine\nIf the problem persists anyway, you can open an issue at $url/issues" ; exit 1; }
			echo -e "\n$pkgname has been successfully updated to version $latest_release\nPlease, visit $url for more information"
			exit 0
		;;
		*)
			exit 1
		;;
	esac
else
	echo "$pkgname is up to date -- reinstallation"
	read -rp $'Proceed with installation ? [Y/n] ' answer
	case "$answer" in
		[Yy]|"")
			package || { echo -e >&2 "An error occured during the installation\n\nPlease, verify that you have a working internet connexion and curl installed on your machine\nIf you do and the problem persists, you can open an issue at $url/issues" ; exit 1; }
			echo -e "\n$pkgname has been successfully reinstalled\nPlease, visit $url for more information"
			exit 0
		;;
		*)
			exit 0
		;;
	esac
fi
