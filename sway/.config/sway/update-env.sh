#!/bin/bash

# Most variable/env management are already handled in the config files provided by the sway(fx) package
# (ie. /etc/sway/config.d/* )

# Unlock the gnome keyring
gnome-keyring-daemon --start --components=secrets
