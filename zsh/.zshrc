#!/bin/zsh

autoload zmv

# Bootstrap Antigen
ANTIGEN_PATH="$HOME/antigen.zsh"
if [[ ! -f $ANTIGEN_PATH ]]; then
    curl -L git.io/antigen > $ANTIGEN_PATH
    # or use git.io/antigen-nightly for the latest version
fi

# Plugins
source $ANTIGEN_PATH
antigen init ~/.antigenrc

# Configuration

# If you come from bash you might have to change your $PATH.
path=('/snap/bin' $path)
path=("$HOME/.local/bin" $path)
path=("$HOME/.cargo/bin" $path)
export PATH

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Preferred editor based on nvim availability
if command -v nvim > /dev/null; then
  export VISUAL='nvim'
else
  export VISUAL='vim'
fi
export EDITOR="$VISUAL"

# tmuxp autocomplete
# if [ -x "$(command -v tmuxp)" ]; then
#     eval "$(_TMUXP_COMPLETE=source_zsh tmuxp)"
# fi

# use custom aliases
if [ -f "$HOME/.aliases" ]; then
    source "$HOME/.aliases"
fi

export COLORTERM=truecolor
export GPG_TTY=$(tty)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
