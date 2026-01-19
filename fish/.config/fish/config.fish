if set -q SSH_CLIENT || set -q SSH_TTY
  export PINENTRY_USER_DATA="USE_TTY"
end

if status is-interactive
    starship init fish | source
end

bind \e\[1\;5C forward-word
bind \e\[1\;5D backward-word
set fish_greeting ""
