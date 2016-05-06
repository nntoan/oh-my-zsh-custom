#!/bin/zsh
# ------------------------------------------------------------------------------
# FILE: autossh.plugin.zsh
# DESCRIPTION: This is an SSH-D proxy with auto-reconnect on disconnect
# AUTHOR: Toan Nguyen (nntoan at protonmail dot com)
# VERSION: 1.0.0
# ------------------------------------------------------------------------------

function autosshd() {
  # Colour fields
  local GRNTXT="${fg[green]}"
  local REDTXT="${fg[red]}"
  local BLUETXT="${fg[blue]}"
  # Core fields
  local ALIVE=0
  
  read -p "Please specify your SSH user: " remote_user
  read -p "Please specify your bloody IP or alias: " remote_ip

  # Infinitie Loop
  while true; do
    local exists=`ps aux | grep $remote_user@$remote_ip | grep 22`
    if test -n "$exists"
    then
      if test $ALIVE -eq 0
      then
        echo $GRNTXT "I'm alive since $(date)..."
      fi
      ALIVE=1
    else
      ALIVE=0
      echo $REDTXT "I'm dead... God is bringing me back..."
      clear
      for i in {1..100}; do
        printf "XXX\n%d\n%(%a %b %T)T progress: %d\nXXX\n" $i -1 $i
        sleep .033
        done
      ssh $remote_user@$remote_ip
    fi
    sleep 1
done
}
