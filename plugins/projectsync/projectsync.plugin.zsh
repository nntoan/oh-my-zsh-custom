#!/usr/bin/env zsh
#
# Set Colors
#
# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  bold="$(tput bold)"
  underline=$(tput sgr 0 1)
  reset="$(tput sgr0)"
  red="$(tput setaf 1)"
  green="$(tput setaf 2)"
  yellow="$(tput setaf 3)"
  blue="$(tput setaf 4)"
  purple=$(tput setaf 171)
  tan=$(tput setaf 3)
else
  bold=""
  underline=""
  reset=""
  red=""
  green=""
  yellow=""
  blue=""
  purple=""
  tan=""
fi

function copy-from-workspace {
  local target="$1"
  if [ $# -eq 0 ]; then
    echo "${red}You need to specified the target file or directory${reset}" >&2
    exit 1
  fi

  if [ -d "$target" ]; then
    target="$1/"
  fi

  /usr/local/bin/rsync --quiet --recursive $(__get_workspace_dir)/"$target" "$target" 2>/dev/null

  if [ $? -eq 0 ]; then
    echo "${green}OK${reset}"
  else
    echo "${red}No such fucking file or directory.${reset}"
  fi
}

function copy-from-clean {
  local target="$1"
  if [ $# -eq 0 ]; then
    echo "${red}You need to specified the target file or directory${reset}" >&2
    exit 1
  fi

  if [ -d "$target" ]; then
    target="$1/"
  fi

  /usr/local/bin/rsync --quiet --recursive $(__get_clean_dir)/"$target" "$target" 2>/dev/null

  if [ $? -eq 0 ]; then
    echo "${green}OK${reset}"
  else
    echo "${red}No such fucking file or directory.${reset}"
  fi
}

function __get_current_dir {
  echo "$(pwd)"
}

function __get_workspace_dir {
  local current_dir=$(__get_current_dir)
  echo ${current_dir/-clean/}
}

function __get_clean_dir {
  local current_dir=$(__get_current_dir)
  local prepath=${current_dir%/*}-clean
  local lastpath=${current_dir##*/}
  echo "$prepath/$lastpath"
}
