#!/bin/bash

echo "Which dotfiles would you like to install?"

for dotfile in $(find . -maxdepth 1 -name ".*" -not -name ".DS_Store" -not -name ".git" -not -name "." -not -name ".."); do
	dotfile="${dotfile:2}" # trim leading characters

	read -p "Install ${dotfile}? " answer
	if [ "$answer" == "y" ] || [ "$answer" == "Y" ]; then
		echo ln -s "$(pwd)/$dotfile" "~/$dotfile"
	fi

	# program-specific additional steps
	case $dotfile in
		.vimrc)
			nvim -u ~/.vimrc +qall
			;;
		*)
			;;
	esac

done
