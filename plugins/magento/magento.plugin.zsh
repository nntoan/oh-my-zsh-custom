# ------------------------------------------------------------------------------
# FILE: magento.plugin.zsh
# DESCRIPTION: oh-my-zsh magento plugin file.
# AUTHOR: Toan Nguyen (nntoan at protonmail dot com)
# VERSION: 1.0.0
# ------------------------------------------------------------------------------

# magento basic command completion
_magento_get_command_list () {
  $_comp_command1 --no-ansi | sed "1,/Available commands/d" | awk '/^ +[a-z\-:]+/ { print $1 }'
}


_magento () {
  _arguments '1: :->command' '*:optional arg:_files'

  case $state in
    command)
      compadd $(_magento_get_command_list)
      ;;
    *)
  esac
}

compdef _magento magento
