#!/bin/sh

# default is $HOME/go, but I prefer $HOME/.go
export GOPATH="$HOME/.go"
export NVM_DIR="$HOME/.nvm"

function _prepend-path() {
  case ":${PATH}:" in
    *:"$1":*)
      ;; # already in PATH
    *)
      export PATH="$1:$PATH"
      ;;
  esac
}

_prepend-path "/snap/bin"
_prepend-path "/usr/local/go/bin"
_prepend-path "$GOPATH/bin"
if [ -e "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
_prepend-path "$HOME/.local/bin"

export COLORTERM=truecolor
export GPG_TTY="$(tty)"

# Use nvim if available, otherwise use vim
export VISUAL="$(command -v nvim || command -v vim)"
export EDITOR="$VISUAL"

# Start fish on session start
if [[ $(ps --no-header --pid="$PPID" --format=comm) != "fish" && -z ''${ZSH_EXECUTION_STRING} ]]
then
  [[ -o login ]] && LOGIN_OPTION='--login' || LOGIN_OPTION=""
  exec fish "$LOGIN_OPTION"
fi
