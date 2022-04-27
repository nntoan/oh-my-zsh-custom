# ------------------------------------------------------------------------------
# FILE: magento.plugin.zsh
# DESCRIPTION: oh-my-zsh magento plugin file.
# AUTHOR: Toan Nguyen (hello at nntoan dot com)
# VERSION: 1.0.0
# ------------------------------------------------------------------------------

_magento () {
  local curcontext="$curcontext" state line
  typeset -A opt_args
  _arguments '*:: :->subcmds'

  if (( CURRENT == 1 )); then
    $_comp_command1 --no-ansi | sed "1,/Available commands/d" | awk '/^[ \t]*[a-z]+/ { print $1 }'
  fi
}

compdef _magento magento
compdef _magento bin/magento
