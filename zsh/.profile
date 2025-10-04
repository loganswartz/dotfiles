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
if [ -x "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
_prepend-path "$HOME/.local/bin"

export COLORTERM=truecolor
export GPG_TTY="$(tty)"

# Use nvim if available, otherwise use vim
export VISUAL="$(command -v nvim || command -v vim)"
export EDITOR="$VISUAL"
