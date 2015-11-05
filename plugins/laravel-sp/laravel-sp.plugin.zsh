 Laravel4 basic command completion
_laravel4_get_command_list () {
        php5.6-sp artisan --no-ansi | sed "1,/Available commands/d" | awk '/^ +[a-z]+/ { print $1 }'
}

_laravel4 () {
  if [ -f artisan ]; then
    compadd `_laravel4_get_command_list`
  fi
}

compdef _laravel4 artisan
compdef _laravel4 la4

#Alias
alias la4='php5.6-sp artisan'

alias la4dump='php5.6-sp artisan dump-autoload'
alias la4cache='php5.6-sp artisan cache:clear'
alias la4routes='php5.6-sp artisan routes'
