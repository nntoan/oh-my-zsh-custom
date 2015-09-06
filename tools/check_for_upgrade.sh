#!/usr/bin/env zsh

zmodload zsh/datetime

function _current_epoch() {
  echo $(( $EPOCHSECONDS / 60 / 60 / 24 ))
}

function _update_zsh_custom_update() {
  echo "LAST_EPOCH=$(_current_epoch)" >! ~/.zsh-cusstom-update
}

function _upgrade_zsh_custom() {
  env ZSH_CUSTOM=$ZSH_CUSTOM /bin/sh $ZSH_CUSTOM/tools/upgrade.sh
  # update the zsh file
  _update_zsh_update
}

epoch_target=$UPDATE_ZSH_DAYS
if [[ -z "$epoch_target" ]]; then
  # Default to old behavior
  epoch_target=13
fi

# Cancel upgrade if the current user doesn't have write permissions for the
# oh-my-zsh-custom directory.
[[ -w "$ZSH_CUSTOM" ]] || return 0

if [ -f ~/.zsh-custom-update ]
then
  . ~/.zsh-custom-update

  if [[ -z "$LAST_EPOCH" ]]; then
    _update_zsh_custom_update && return 0;
  fi

  epoch_diff=$(($(_current_epoch) - $LAST_EPOCH))
  if [ $epoch_diff -gt $epoch_target ]
  then
    if [ "$DISABLE_UPDATE_PROMPT" = "true" ]
    then
      _upgrade_zsh_custom
    else
      echo "[Oh My Zsh Custom] Would you like to check for updates? [Y/n]: \c"
      read line
      if [ "$line" = Y ] || [ "$line" = y ] || [ -z "$line" ]; then
        _upgrade_zsh_custom
      else
        _update_zsh_custom_update
      fi
    fi
  fi
else
  # create the zsh file
  _update_zsh_custom_update
fi
