#!/bin/bash

#Clear the screen
clear >"$(tty)"

#This is basically the same code as the "list" part of the "remove" function
alias | grep -v "alias alias_manager='source ~/.alias_manager/alias_manager.sh'" | awk '{$1=""}1' | sed "s/ //" > ~/.alias_manager/.alias_list.txt || exit 1

echo -e "Alias list :\n"
alias_number=$(wc -l ~/.alias_manager/.alias_list.txt | awk '{print $1}')
i=1
until [ "$i" -gt "$alias_number" ]; do
	echo "$i - $(sed -n "$i"p ~/.alias_manager/.alias_list.txt)" || exit 1
	((i=i+1))
done

rm -f ~/.alias_list.txt
