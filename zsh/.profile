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
if command -v luarocks > /dev/null; then
  eval "$(luarocks path)"
fi
_prepend-path "$GOPATH/bin"
if [ -e "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
_prepend-path "$HOME/.local/bin"

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi

export COLORTERM=truecolor
export GPG_TTY="$(tty)"

# Use nvim if available, otherwise use vim
export VISUAL="$(command -v nvim || command -v vim)"
export EDITOR="$VISUAL"

if ! command -v "fish" > /dev/null; then
  echo "Fish is not installed, so you are using zsh."
  return
fi

# Start fish on session start
# only replace if TTY attached, not already in fish, and not executing a command via "zsh -c ..."
if [[ -t 0 && $(ps -p "$PPID" -c -o comm=) != "fish" && -z ''${ZSH_EXECUTION_STRING} ]]
then
  if [[ -o login ]]; then
    exec fish --login
  else
    exec fish
  fi
fi
