# ------------------------------------------------------------------------------
# FILE: n98-magerun-sp.plugin.zsh
# DESCRIPTION: oh-my-zsh n98-magerun plugin file. ServerPilot version 
# AUTHOR: Toan Nguyen (nntoan at protonmail dot com)
# VERSION: 1.0.0
# ------------------------------------------------------------------------------

# n98-magerun basic command completion
_n98_magerun_get_command_list () {
  $_comp_command1 --no-ansi | sed "1,/Available commands/d" | awk '/^ +[a-z\-:]+/ { print $1 }'
}


_n98_magerun () {
  _arguments '1: :->command' '*:optional arg:_files'

  case $state in
    command)
      compadd $(_n98_magerun_get_command_list)
      ;;
    *)
  esac
}

compdef _n98_magerun n98-magerun.phar
compdef _n98_magerun n98-magerun
compdef _n98_magerun magerun

# Install n98-magerun into the current directory
alias mage-get='wget http://files.magerun.net/n98-magerun-latest.phar -O /tmp/n98-magerun.phar'
alias mage-install='sudo chmod +x /tmp/n98-magerun.phar && sudo mv /tmp/n98-magerun.phar /usr/local/bin/magerun'
