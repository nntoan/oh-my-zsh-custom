#!/usr/bin/env zsh
#######################
# BALANCE BOX MANAGER #
#######################
function balance()
{
  local BALANCEBOX_PLUGIN_DIR=$ZSH_CUSTOM/plugins/balancebox-manager
  local BALANCEBOX_VAGRANT_DIR=$HOME/Vagrant/balance-dev-machine
  local BALANCEBOX_MACHINE="${fg[green]}balance-dev-machine${fg[blue]}"
  local BALANCEBOX_MACHINE_ANSI="balance-dev-machine"
  local WORKING_DIR=$PWD
  local BALANCEBOX_ID=$VAGRANTBOX_ID
  local BALANCEBOX_STATUS=0

  if [[ -d "$BALANCEBOX_VAGRANT_DIR" ]]; then
    _balance_check_status
    case "$1" in
      up)
        _balance_up
      ;;
      ssh)
        _balance_process_query login
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
    echo $fg[red] "Vagrant folder is not found. Please re-check, it must be located at ${BALANCEBOX_VAGRANT_DIR}"
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
  if [[ $BALANCEBOX_STATUS -eq 1 ]]; then
    case "$1" in
      start)
        echo "${fg[blue]}You're logging in now...${reset_color}\n" && vagrant ssh "$BALANCEBOX_ID"
      ;;
      halt)
        echo "${fg[blue]}We are going to shutting down the ${BALANCEBOX_MACHINE}..."
        vagrant halt "$BALANCEBOX_ID" &> /dev/null
        echo "${BALANCEBOX_MACHINE} is already poweroff now. You are free to go!"
      ;;
      save)
        echo "${fg[blue]}We are going to suspending the ${BALANCEBOX_MACHINE}..."
        vagrant suspend "$BALANCEBOX_ID" &> /dev/null
        echo "${BALANCEBOX_MACHINE} is already saved now. You are free to go!"
      ;;
      reload)
        echo "${fg[blue]}We are going to restart and reload the ${BALANCEBOX_MACHINE}..."
        vagrant reload "$BALANCEBOX_ID" &> /dev/null
        echo "${BALANCEBOX_MACHINE} is already to use now."
        echo "${fg[blue]}You're logging in now...${reset_color}\n" && vagrant ssh "$BALANCEBOX_ID"
      ;;
      login)
        echo "${fg[blue]}You're logging in now...${reset_color}\n" && vagrant ssh "$BALANCEBOX_ID"
      ;;
    esac
  else
    case "$1" in
      start)
        echo "${fg[blue]}Start booting ${BALANCEBOX_MACHINE}, please be patient..."
        vagrant reload "$BALANCEBOX_ID" &> /dev/null
        echo "${BALANCEBOX_MACHINE} is ready to use."
        echo "You're logging in now...${reset_color}\n" && vagrant ssh "$BALANCEBOX_ID"
      ;;
    esac
  fi
}
function _balance_check_status()
{
  vagrant status "$BALANCEBOX_ID" | grep 'running' &> /dev/null
  if [[ $? -eq 0 ]]; then
    BALANCEBOX_STATUS=1
  else
    BALANCEBOX_STATUS=0
  fi
}
function _balance_process_autodetect_config()
{
  local ip=`ipconfig getifaddr en0`
  rsync $BALANCEBOX_PLUGIN_DIR/files/vagrantfile/balance/Vagrantfile $BALANCEBOX_VAGRANT_DIR/Vagrantfile &>/dev/null
  echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}BALANCE[en0] ${fg[blue]}connection. (Public IP: ${fg[red]}${ip})"
}
function _balance_process_compactdisk()
{
  $DISK=$HOME/VirtualBox/balance_dev_machine/box-disk1.vdi
  VBoxManage modifyhd --compact ~/VirtualBox/balance_dev_machine/box-disk1.vdi &>/dev/null
}
function _balance_process_status()
{
  vagrant status "$BALANCEBOX_ID" | grep 'running' &>/dev/null
  if [[ $? -eq 0 ]]; then
    echo "${BALANCEBOX_MACHINE}${fg[blue]} is running..."
  else
    echo "${BALANCEBOX_MACHINE}${fg[blue]} is not running..."
  fi
}
function _balance_show_help()
{
  case "$1" in
    --ansi)
        echo $fg[black] ""; box "BALANCE-DEV BOX MANAGER"

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
        echo $fg[green] "up${reset_color}               Start, provisioning and login to ${BALANCEBOX_MACHINE_ANSI}."
        echo $fg[green] "ssh${reset_color}              Login to ${BALANCEBOX_MACHINE_ANSI}."
        echo $fg[green] "down${reset_color}             Stops ${BALANCEBOX_MACHINE_ANSI} and go to previous working dir."
        echo $fg[green] "save${reset_color}             Suspends ${BALANCEBOX_MACHINE_ANSI} and go to previous working dir."
        echo $fg[green] "restart${reset_color}          Restart ${BALANCEBOX_MACHINE_ANSI}, loads new config file."
        echo $fg[green] "compact${reset_color}          Compact virtual disk to save space."
    ;;
    --no-ansi)
        echo ""; box "BALANCE-DEV BOX MANAGER"

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
        echo " up ${reset_color}              Start, provisioning and login to ${BALANCEBOX_MACHINE_ANSI}."
        echo " ssh${reset_color}              Login to ${BALANCEBOX_MACHINE_ANSI}."
        echo " down${reset_color}             Stops ${BALANCEBOX_MACHINE_ANSI} and go to previous working dir."
        echo " save${reset_color}             Suspends ${BALANCEBOX_MACHINE_ANSI} and go to previous working dir."
        echo " restart${reset_color}          Restart ${BALANCEBOX_MACHINE_ANSI}, loads new config file."
        echo " compact${reset_color}          Compact virtual disk to save space."
    ;;
  esac
}
