# ------------------------------------------------------------------------------
#          FILE:  valet.plugin.zsh
#   DESCRIPTION:  oh-my-zsh-custom valet plugin file.
#        AUTHOR:  Toan Nguyen (hello at nntoan dot com)
#       VERSION:  1.0.0
# ------------------------------------------------------------------------------

autoload -Uz is-at-least;

## Basic Valet command completion
# Since Zsh 5.7, an improved valet command completion is provided
if ! is-at-least 5.7; then
  _valet () {
    local curcontext="$curcontext" state line
    typeset -A opt_args
    _arguments '*:: :->subcmds'

    if (( CURRENT == 1 )) || ( (( CURRENT == 2 )) && [[ "$words[1]" = "global" ]] ); then
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
      _describe -t commands 'valet command' subcmds
    else
      # Valet's domain list
      compadd $($_comp_command1 links --no-ansi 2>/dev/null \
        | awk 'NR>3 && !/^\+/ {gsub("\.[^.]*$","",$2); print $2}')
    fi
  }

  compdef _valet valet
else
  _valet () {
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
      _describe -t commands 'valet command' subcmds
    else
      # Valet's domain list
      compadd $($_comp_command1 links --no-ansi 2>/dev/null \
        | awk 'NR>3 && !/^\+/ {gsub("\.[^.]*$","",$2); print $2}')
    fi
  }

  compdef _valet valet
fi

## Aliases
alias v='valet'
alias vadd='valet link'
alias vrm='valet unlink'
alias vssl='valet secure'
alias vls='valet links'
alias vp='valet park'
alias vu='valet use'
alias vxdb='valet xdebug'
alias vion='valet ioncube'

## If Valet not found, try to add known directories to $PATH
if (( ! $+commands[valet] )); then
  [[ -d "$HOME/.composer/vendor/bin" ]] && export PATH="$PATH:$HOME/.composer/vendor/bin"
  [[ -d "$HOME/.config/composer/vendor/bin" ]] && export PATH="$PATH:$HOME/.config/composer/vendor/bin"

  # If still not found, don't do the rest of the script
  (( $+commands[valet] )) || return 0
fi
