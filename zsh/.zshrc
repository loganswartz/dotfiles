#!/bin/zsh

# Bootstrap Antigen
ANTIGEN_PATH="$HOME/.antigen.zsh"
if [[ ! -f $ANTIGEN_PATH ]]; then
    curl -L git.io/antigen > $ANTIGEN_PATH
    # or use git.io/antigen-nightly for the latest version
fi

# Plugins
source $ANTIGEN_PATH
antigen init ~/.antigenrc

# Configuration

# If you come from bash you might have to change your $PATH.
path+=("$HOME/.local/bin")
path+=('/snap/bin')
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
eval "$(_TMUXP_COMPLETE=source_zsh tmuxp)"

# use custom aliases
if [ -f "$HOME/.aliases" ]; then
    source "$HOME/.aliases"
fi
