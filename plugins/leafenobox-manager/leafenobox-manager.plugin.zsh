#!/usr/bin/env zsh
#######################
# LEAFENO BOX MANAGER #
#######################
function leafeno()
{
  local LEAFENOBOX_PLUGIN_DIR=$ZSH_CUSTOM/plugins/leafenobox-manager
  local LEAFENOBOX_VAGRANT_DIR=$HOME/Vagrant/leafeno-dev-machine
  local LEAFENOBOX_MACHINE="${fg[green]}leafeno-dev-machine${fg[blue]}"
  local LEAFENOBOX_MACHINE_ANSI="leafeno-dev-machine"
  local WORKING_DIR=$PWD
  local LEAFENOBOX_ID=$VAGRANTBOX_ID
  local LEAFENOBOX_STATUS=0

  if [[ -d "$LEAFENOBOX_VAGRANT_DIR" ]]; then
    _leafeno_check_status
    case "$1" in
      up)
        _leafeno_up
      ;;
      ssh)
        _leafeno_process_query login
      ;;
      down)
        _leafeno_process_query halt && `cd $WORKING_DIR`
      ;;
      save)
        _leafeno_process_query save && `cd $WORKING_DIR`
      ;;
      restart)
        _leafeno_restart
      ;;
      compact)
        _leafeno_process_compactdisk && _leafeno_up
      ;;
      --no-ansi)
        _leafeno_show_help --no-ansi
      ;;
      *|help|-h|--help|--ansi)
        _leafeno_show_help --ansi
      ;;
    esac
  else
    echo $fg[red] "Vagrant folder is not found. Please re-check, it must be located at ${LEAFENOBOX_VAGRANT_DIR}"
  fi
}
function _leafeno_up()
{
  echo "${fg[blue]}Check current proxy connection...";
  _leafeno_process_autodetect_config && _leafeno_process_query start
}
function _leafeno_restart()
{
  echo "${fg[blue]}Check current proxy connection...";
  _leafeno_process_autodetect_config && _leafeno_process_query reload
}
function _leafeno_process_query()
{
  if [[ $LEAFENOBOX_STATUS -eq 1 ]]; then
    case "$1" in
      start)
        echo "${fg[blue]}You're logging in now...${reset_color}\n" && vagrant ssh "$LEAFENOBOX_ID"
      ;;
      halt)
        echo "${fg[blue]}We are going to shutting down the ${LEAFENOBOX_MACHINE}..."
        vagrant halt "$LEAFENOBOX_ID" &> /dev/null
        echo "${LEAFENOBOX_MACHINE} is already poweroff now. You are free to go!"
      ;;
      save)
        echo "${fg[blue]}We are going to suspending the ${LEAFENOBOX_MACHINE}..."
        vagrant suspend "$LEAFENOBOX_ID" &> /dev/null
        echo "${LEAFENOBOX_MACHINE} is already saved now. You are free to go!"
      ;;
      reload)
        echo "${fg[blue]}We are going to restart and reload the ${LEAFENOBOX_MACHINE}..."
        vagrant reload "$LEAFENOBOX_ID" &> /dev/null
        echo "${LEAFENOBOX_MACHINE} is already to use now."
        echo "${fg[blue]}You're logging in now...${reset_color}\n" && vagrant ssh "$LEAFENOBOX_ID"
      ;;
      login)
        echo "${fg[blue]}You're logging in now...${reset_color}\n" && vagrant ssh "$LEAFENOBOX_ID"
      ;;
    esac
  else
    case "$1" in
      start)
        echo "${fg[blue]}Start booting ${LEAFENOBOX_MACHINE}, please be patient..."
        vagrant reload "$LEAFENOBOX_ID" &> /dev/null
        echo "${LEAFENOBOX_MACHINE} is ready to use."
        echo "You're logging in now...${reset_color}\n" && vagrant ssh "$LEAFENOBOX_ID"
      ;;
    esac
  fi
}
function _leafeno_check_status()
{
  vagrant status "$LEAFENOBOX_ID" | grep 'running' &> /dev/null
  if [[ $? -eq 0 ]]; then
    LEAFENOBOX_STATUS=1
  else
    LEAFENOBOX_STATUS=0
  fi
}
function _leafeno_process_autodetect_config()
{
  local ip=`ipconfig getifaddr en0`
  rsync $LEAFENOBOX_PLUGIN_DIR/files/vagrantfile/leafeno/Vagrantfile $LEAFENOBOX_VAGRANT_DIR/Vagrantfile &>/dev/null
  echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}LEAFENO[en0] ${fg[blue]}connection. (Public IP: ${fg[red]}${ip})"
}
function _leafeno_process_compactdisk()
{
  $DISK=$HOME/VirtualBox/leafeno_dev_machine/box-disk1.vdi
  VBoxManage modifyhd --compact ~/VirtualBox/leafeno_dev_machine/box-disk1.vdi &>/dev/null
}
function _leafeno_process_status()
{
  vagrant status "$LEAFENOBOX_ID" | grep 'running' &>/dev/null
  if [[ $? -eq 0 ]]; then
    echo "${LEAFENOBOX_MACHINE}${fg[blue]} is running..."
  else
    echo "${LEAFENOBOX_MACHINE}${fg[blue]} is not running..."
  fi
}
function _leafeno_show_help()
{
  case "$1" in
    --ansi)
        echo $fg[black] ""; box "LEAFENO-DEV BOX MANAGER"

        echo

        echo "${fg[yellow]}Usage:"
        echo $reset_color "leafeno [commands] [options]"

        echo

        echo "${fg[yellow]}Options:"
        echo $fg[green] "--help${reset_color}(-h)       Display this help message."
        echo $fg[green] "--quiet${reset_color}(-q)      Do not output any message."
        echo $fg[green] "--ansi${reset_color}           Force ANSI output."
        echo $fg[green] "--no-ansi${reset_color}        Disable ANSI output."

        echo

        echo "${fg[yellow]}Available commands:"
        echo $fg[green] "up${reset_color}               Start, provisioning and login to ${LEAFENOBOX_MACHINE_ANSI}."
        echo $fg[green] "ssh${reset_color}              Login to ${LEAFENOBOX_MACHINE_ANSI}."
        echo $fg[green] "down${reset_color}             Stops ${LEAFENOBOX_MACHINE_ANSI} and go to previous working dir."
        echo $fg[green] "save${reset_color}             Suspends ${LEAFENOBOX_MACHINE_ANSI} and go to previous working dir."
        echo $fg[green] "restart${reset_color}          Restart ${LEAFENOBOX_MACHINE_ANSI}, loads new config file."
        echo $fg[green] "compact${reset_color}          Compact virtual disk to save space."
    ;;
    --no-ansi)
        echo ""; box "LEAFENO-DEV BOX MANAGER"

        echo

        echo "Usage:"
        echo " leafeno [commands] [options]"

        echo

        echo "Options:"
        echo " --help${reset_color}(-h)       Display this help message."
        echo " --quiet${reset_color}(-q)      Do not output any message."
        echo " --ansi${reset_color}           Force ANSI output."
        echo " --no-ansi${reset_color}        Disable ANSI output."

        echo

        echo "Available commands:"
        echo " up ${reset_color}              Start, provisioning and login to ${LEAFENOBOX_MACHINE_ANSI}."
        echo " ssh${reset_color}              Login to ${LEAFENOBOX_MACHINE_ANSI}."
        echo " down${reset_color}             Stops ${LEAFENOBOX_MACHINE_ANSI} and go to previous working dir."
        echo " save${reset_color}             Suspends ${LEAFENOBOX_MACHINE_ANSI} and go to previous working dir."
        echo " restart${reset_color}          Restart ${LEAFENOBOX_MACHINE_ANSI}, loads new config file."
        echo " compact${reset_color}          Compact virtual disk to save space."
    ;;
  esac
}
