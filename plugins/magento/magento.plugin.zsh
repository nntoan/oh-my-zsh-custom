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
    # Command list
    local -a subcmds
    subcmds=("${(@f)"$($_comp_command1 --no-ansi 2>/dev/null | awk '
      /Available commands/{ r=1 }
      r == 1 && /^[ \t]*[a-z]+/{
        gsub(/^[ \t]+/, "")
        gsub(/  +/, ":")
        print $0
      }
    ')"}")
    _describe -t commands 'magento command' subcmds
  fi
}

compdef _magento magento
compdef _magento bin/magento
