printf '\033[0;34m%s\033[0m\n' "Upgrading Oh My Zsh Custom"
if [ -f "/usr/local/bin/autossh" ]; then
  sudo \/bin/cp "$ZSH_CUSTOM/tools/autossh" /usr/local/bin/autossh;
fi
cd "$ZSH_CUSTOM"
if git pull --rebase --stat origin master
then
  printf '\033[0;32m%s\033[0m\n' '         __                                     __                       __                '
  printf '\033[0;32m%s\033[0m\n' '  ____  / /_     ____ ___  __  __   ____  _____/ /_     _______  _______/ /_____  ____ ___ '
  printf '\033[0;32m%s\033[0m\n' ' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \   / ___/ / / / ___/ __/ __ \/ __ `__ \'
  printf '\033[0;32m%s\033[0m\n' '/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / /  / /__/ /_/ (__  ) /_/ /_/ / / / / / /'
  printf '\033[0;32m%s\033[0m\n' '\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/   \___/\__,_/____/\__/\____/_/ /_/ /_/ '
  printf '\033[0;32m%s\033[0m\n' '                        /____/                                                             '
  printf '\033[0;34m%s\033[0m\n' 'Hooray! Oh My Zsh Custom has been updated and/or is at the current version.'
  printf '\033[0;34m%s\033[1m%s\033[0m\n' 'To keep up on the latest news and updates, follow us on github: ' 'https://github.com/nntoan/oh-my-zsh-custom'
else
  printf '\033[0;31m%s\033[0m\n' 'There was an error updating. Try again later?'
fi
