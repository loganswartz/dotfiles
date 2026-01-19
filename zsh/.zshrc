#!/bin/zsh

if [ ! -d "$HOME/.zshrc.d" ]; then
  mkdir "$HOME/.zshrc.d"
fi

if [ "$SSH_CONNECTION" != "" ]; then
  export PINENTRY_USER_DATA="USE_TTY"
fi

autoload zmv

eval "$(starship init zsh)"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# use custom aliases
if [ -f "$HOME/.aliases" ]; then
  source "$HOME/.aliases"
fi

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion
