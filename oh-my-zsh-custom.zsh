# Check for updates on initial load...
if [ "$DISABLE_AUTO_UPDATE" != "true" ]; then
    env ZSH=$ZSH DISABLE_UPDATE_PROMPT=$DISABLE_UPDATE_PROMPT zsh -f $ZSH_CUSTOM/tools/check_for_upgrade.sh
fi

# Set ZSH_CUSTOM to the path where your custom config files
# and plugins exists, or else we will use the default custom/
if [[ -z "$ZSH_CUSTOM" ]]; then
    ZSH_CUSTOM="$ZSH-custom"
fi

# Setup iTerm2 Shell Integration...
if [ "$ITERM2_SHELL_INTEGRATION" != "true" ]; then
    env ZSH=$ZSH ITERM2_SHELL_INTEGRATION=$ITERM2_SHELL_INTEGRATION
    source $ZSH_CUSTOM/tools/iterm2_shell_integration.zsh
fi
