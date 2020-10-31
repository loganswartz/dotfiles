#!/bin/bash

echo "Which dotfiles would you like to install?"

resolve() {
	echo "$(echo "$1" | python3 -c 'import sys; import pathlib; print(pathlib.Path(sys.stdin.read()).expanduser().resolve())')"
}

install() {
	dotfile="$1"
	# backup existing dotfile
	if [ -f "$HOME/$dotfile" ]; then
		mv "$HOME/$dotfile{,.orig}"
	fi

	# install the dotfile
	#dir=$(readlink -m "$(pwd)/$(dirname $0)")
	ln -s "$(resolve "$(dirname $0)/$dotfile")" "$HOME/$dotfile"
}

for dotfile in $(find "$(dirname $0)" -maxdepth 1 -name ".*" -not -name ".DS_Store" -not -name ".git" -not -name "." -not -name ".."); do
	dotfile="$(basename $dotfile)"   # trim off preceeding parts of path

	read -p "Install ${dotfile}? " answer
	if [ "$answer" == "y" ] || [ "$answer" == "Y" ] || [ "$answer" == "yes" ] || [ "$answer" == "Yes" ]; then
		# program-specific pre-install steps
		case $dotfile in
			*)
				;;
		esac

		install "$dotfile"

		# program-specific post-install steps
		case $dotfile in
			.vimrc)
				if command -v nvim; then
					VIM_EXEC="nvim"
				else
					VIM_EXEC="vim"
				fi
				$VIM_EXEC -u "$HOME/.vimrc" +qall
				$VIM_EXEC +PlugInstall +qall
				# install coc.nvim settings file if installing vimrc
				ln -s "$dir/coc-settings.json" "$HOME/.config/nvim/coc-settings.json"
				;;
			*)
				;;
		esac
	fi

done
