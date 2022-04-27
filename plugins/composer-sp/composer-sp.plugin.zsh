# ------------------------------------------------------------------------------
#          FILE:  composer-sp.plugin.zsh
#   DESCRIPTION:  oh-my-zsh-custom composer serverpilot plugin file.
#        AUTHOR:  Toan Nguyen (hello at nntoan dot com)
#       VERSION:  1.0.0
# ------------------------------------------------------------------------------

# Composer basic command completion
_composer_get_command_list () {
    $_comp_command1 --no-ansi | sed "1,/Available commands/d" | awk '/^[ \t]*[a-z]+/ { print $1 }'
}

_composer_get_required_list () {
    $_comp_command1 show -s --no-ansi | sed '1,/requires/d' | awk 'NF > 0 && !/^requires \(dev\)/{ print $1 }'
}

_composer () {
  local curcontext="$curcontext" state line
  typeset -A opt_args
  _arguments \
    '1: :->command'\
    '*: :->args'

  case $state in
    command)
      compadd $(_composer_get_command_list)
      ;;
    *)
      compadd $(_composer_get_required_list)
      ;;
  esac
}

compdef _composer composer5.4-sp
compdef _composer composer5.5-sp
compdef _composer composer5.6-sp
compdef _composer composer7.0-sp
compdef _composer composer
