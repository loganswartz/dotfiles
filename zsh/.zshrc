#!/bin/zsh

if [ ! -d "$HOME/.zshrc.d" ]; then
  mkdir "$HOME/.zshrc.d"
fi

autoload zmv

# Bootstrap Antigen
ANTIGEN_PATH="$HOME/.antigen.zsh"
if [[ ! -f $ANTIGEN_PATH ]]; then
  curl -L git.io/antigen > "$ANTIGEN_PATH"
  # or use git.io/antigen-nightly for the latest version
fi

# Plugins
source "$ANTIGEN_PATH"
antigen init ~/.antigenrc

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# use custom aliases
if [ -f "$HOME/.aliases" ]; then
  source "$HOME/.aliases"
fi

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion
