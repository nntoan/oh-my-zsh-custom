#!/usr/bin/env zsh

source ~/.oh-my-zsh-custom/lib/spin.zsh

execute \
    --title \
    "[1/2]: Changing directories permission..." \
    "find . -type d -exec chmod 0755 {} +"

execute \
    --title \
    "[2/2]: Changing files permissions..." \
    "find . -type f -exec chmod 0644 {} +"
