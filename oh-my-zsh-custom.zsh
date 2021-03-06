# Check for updates on initial load...
if [ "$DISABLE_AUTO_UPDATE" != "true" ]; then
    env ZSH_CUSTOM=$ZSH_CUSTOM DISABLE_UPDATE_PROMPT=$DISABLE_UPDATE_PROMPT zsh -f $ZSH_CUSTOM/tools/check_for_upgrade.sh
fi

# Set ZSH_CUSTOM to the path where your custom config files
# and plugins exists, or else we will use the default ~/.oh-my-zsh-custom/
if [[ -z "$ZSH_CUSTOM" ]]; then
    ZSH_CUSTOM="$ZSH-custom"
fi

# Setup iTerm2 Shell Integration...
if [ "$ITERM2_SHELL_INTEGRATION" != "true" ]; then
    env ZSH_CUSTOM=$ZSH_CUSTOM ITERM2_SHELL_INTEGRATION=$ITERM2_SHELL_INTEGRATION
    source $ZSH_CUSTOM/tools/iterm2_shell_integration.zsh
fi

# Set ZSH_CUSTOM_CACHE_DIR to the path where cache files should be created
# or else we will use the default cache/
if [[ -z "$ZSH_CUSTOM_CACHE_DIR" ]]; then
  ZSH_CUSTOM_CACHE_DIR="$ZSH_CUSTOM/cache/"
fi


# Load all of the config files in ~/.oh-my-zsh-custom/lib that end in .zsh
for config_file ($ZSH_CUSTOM/lib/*.zsh); do
  source $config_file
done
