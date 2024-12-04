#!/bin/sh

# default is $HOME/go, but I prefer $HOME/.go
GOPATH="$HOME/.go"
NVM_DIR="$HOME/.nvm"

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
. "$HOME/.cargo/env"
_prepend-path "$HOME/.local/bin"

export COLORTERM=truecolor
export GPG_TTY="$(tty)"

# Use nvim if available, otherwise use vim
export VISUAL="$(command -v nvim || command -v vim)"
export EDITOR="$VISUAL"
