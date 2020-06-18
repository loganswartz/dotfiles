#!/bin/bash

echo "Which dotfiles would you like to install?"

for dotfile in $(find "$(dirname $0)" -maxdepth 1 -name ".*" -not -name ".DS_Store" -not -name ".git" -not -name "." -not -name ".."); do
	dotfile="$(basename $dotfile)"   # trim off preceeding parts of path

	read -p "Install ${dotfile}? " answer
	if [ "$answer" == "y" ] || [ "$answer" == "Y" ] || [ "$answer" == "yes" ] || [ "$answer" == "Yes" ]; then
		# program-specific pre-install steps
		case $dotfile in
			*)
				;;
		esac

		# backup existing dotfile
		if [ -f "$HOME/$dotfile" ]; then
			mv $HOME/$dotfile{,.orig}
		fi

		# install the dotfile
		dir=$(readlink -m "$(pwd)/$(dirname $0)")
		ln -s "$dir/$dotfile" "$HOME/$dotfile"

		# program-specific post-install steps
		case $dotfile in
			.vimrc)
				nvim -u "$HOME/.vimrc" +qall
				nvim +PlugInstall +qall
				;;
			*)
				;;
		esac
	fi

done
