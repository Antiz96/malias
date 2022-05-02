#!/bin/bash

#Get the list of current aliases...
alias_list=$(grep -w "^alias" ~/.bashrc | awk '{$1=""}1' | sed "s/ //")

#...and reformat it correctly with a unique number in front of each aliases
echo -e "Alias list :\n"
i=1
while IFS= read -r line; do
	echo "$i - $line"
	((i=i+1))
done < <(printf '%s\n' "$alias_list")
