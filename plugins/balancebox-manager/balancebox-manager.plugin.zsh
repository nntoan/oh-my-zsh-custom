#!/usr/bin/zsh
local BALANCEBOX_PLUGIN_DIR=$ZSH_CUSTOM/plugins/balancebox_manager

#######################
# BALANCE BOX MANAGER #
#######################
function balance()
{
  WORKING_DIR=$PWD
  BALANCE_DIR=$HOME/Vagrant/balance-dev-machine
  cd $BALANCE_DIR 2> /dev/null

  if [[ $? -eq 0 ]]; then
    case "$1" in
      up)
        _balance_up
      ;;
      ssh)
        _balance_process_ssh
      ;;
      down)
        _balance_process_query halt && `cd $WORKING_DIR`
      ;;
      save)
        _balance_process_query save && `cd $WORKING_DIR`
      ;;
      restart)
        _balance_restart
      ;;
      compact)
        _balance_process_compactdisk && _balance_up
      ;;
      --no-ansi)
        _balance_show_help --no-ansi
      ;;
      *|help|-h|--help|--ansi)
        _balance_show_help --ansi
      ;;
    esac
  else
    echo $fg[red] "Vagrant folder is not found. Please re-check, it must be located at ${HOME}/Vagrant/balance-dev-machine"
  fi
}
function _balance_up()
{
  echo "${fg[blue]}Check current proxy connection...";
  _balance_process_autodetect_config && _balance_process_query start
}
function _balance_restart()
{
  echo "${fg[blue]}Check current proxy connection...";
  _balance_process_autodetect_config && _balance_process_query reload
}
function _balance_process_query()
{
  vagrant status | grep 'running' &> /dev/null
  if [[ $? -eq 0 ]]; then
    case "$1" in
      start)
        echo "${fg[blue]}Start booting ${fg[green]}balance-dev-machine${fg[blue]}, please be patient..."
        vagrant up &> /dev/null
        echo "${fg[green]}balance-dev-machine ${fg[blue]}is ready to use."
        echo "${fg[blue]}You're logging in now...${reset_color}\n" && vagrant ssh
      ;;
      halt)
        echo "${fg[blue]}We are going to shutting down the ${fg[green]}balance-dev-machine${fg[blue]}..."
        vagrant halt &> /dev/null
        echo "${fg[green]}balance-dev-machine ${fg[blue]}is already poweroff now. You are free to go!"
      ;;
      save)
        echo "${fg[blue]}We are going to suspending the ${fg[green]}balance-dev-machine${fg[blue]}..."
        vagrant suspend &> /dev/null
        echo "${fg[green]}balance-dev-machine ${fg[blue]}is already saved now. You are free to go!"
      ;;
      reload)
        echo "${fg[blue]}We are going to restart and reload the ${fg[green]}balance-dev-machine${fg[blue]}..."
        vagrant reload &> /dev/null
        echo "${fg[green]}balance-dev-machine ${fg[blue]}is already to use now."
        echo "${fg[blue]}You're logging in now...${reset_color}\n" && vagrant ssh
      ;;
      login)
        echo "${fg[blue]}You're logging in now...${reset_color}\n" && vagrant ssh
      ;;
    esac
  fi
}
function _balance_process_autodetect_config()
{
  rsync $BALANCEBOX_PLUGIN_DIR/files/vagrantfile/balance/Vagrantfile Vagrantfile &>/dev/null
  echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}BALANCE[BI_001] ${fg[blue]}connection. (Public IP: ${fg[red]}10.0.1.253)"
}
function _balance_process_compactdisk()
{
  $DISK=$HOME/VirtualBox\ VMs/balance_dev_machine/cloned-disk1.vdi
  VBoxManage modifyhd --compact ~/VirtualBox\ VMs/balance_dev_machine/cloned-disk1.vdi &>/dev/null
}
function _balance_process_status()
{
  vagrant status | grep 'running' &>/dev/null
  if [[ $? -eq 0 ]]; then
    echo "${fg[green]}balance-dev-machine${fg[blue]} is running..."
  else
    echo "${fg[green]}balance-dev-machine${fg[blue]} is not running..."
  fi
}
function _balance_show_help()
{
  case "$1" in
    --ansi)
        echo $fg[black] ""; box "balance DEV MACHINE MANAGER"

        echo

        echo "${fg[yellow]}Usage:"
        echo $reset_color "balance [commands] [options]"

        echo

        echo "${fg[yellow]}Options:"
        echo $fg[green] "--help${reset_color}(-h)       Display this help message."
        echo $fg[green] "--quiet${reset_color}(-q)      Do not output any message."
        echo $fg[green] "--ansi${reset_color}           Force ANSI output."
        echo $fg[green] "--no-ansi${reset_color}        Disable ANSI output."

        echo

        echo "${fg[yellow]}Available commands:"
        echo $fg[green] "up${reset_color}               Start, provisioning and login to balance-dev-machine."
        echo $fg[green] "ssh${reset_color}              Login to balance-dev-machine."
        echo $fg[green] "down${reset_color}             Stops balance-dev-machine and go to previous working dir."
        echo $fg[green] "save${reset_color}             Suspends balance-dev-machine and go to previous working dir."
        echo $fg[green] "restart${reset_color}          Restart balance-dev-machine, loads new config file."
        echo $fg[green] "compact${reset_color}          Compact virtual disk to save space."
    ;;
    --no-ansi)
        echo ""; box "balance DEV MACHINE MANAGER"

        echo

        echo "Usage:"
        echo " balance [commands] [options]"

        echo

        echo "Options:"
        echo " --help${reset_color}(-h)       Display this help message."
        echo " --quiet${reset_color}(-q)      Do not output any message."
        echo " --ansi${reset_color}           Force ANSI output."
        echo " --no-ansi${reset_color}        Disable ANSI output."

        echo

        echo "Available commands:"
        echo " up ${reset_color}              Start, provisioning and login to balance-dev-machine."
        echo " ssh${reset_color}              Login to balance-dev-machine."
        echo " down${reset_color}             Stops balance-dev-machine and go to previous working dir."
        echo " save${reset_color}             Suspends balance-dev-machine and go to previous working dir."
        echo " restart${reset_color}          Restart balance-dev-machine, loads new config file."
        echo " compact${reset_color}          Compact virtual disk to save space."
    ;;
  esac
}
