#!/usr/bin/env zsh
########################
# OCTOPIUS BOX MANAGER #
########################
function octopius()
{
  local OCTOBOX_PLUGIN_DIR=$ZSH_CUSTOM/plugins/octobox-manager
  local OCTOBOX_VAGRANT_DIR=$HOME/Sites/DevMachines/octopius.dev
  local OCTOBOX_MACHINE="${fg[green]}octopius-dev-machine"
  local OCTOBOX_MACHINE_ANSI="octopius-dev-machine"
  local WORKING_DIR=$PWD
  local OCTOBOX_ID=$VAGRANTBOX_ID

  if [[ -d "$OCTOBOX_VAGRANT_DIR" ]]; then
    case "$1" in
      up)
        _octopius_up "$2"
      ;;
      ssh)
        _octopius_process_ssh
      ;;
      down)
        _octopius_process_down && `cd $WORKING_DIR`
      ;;
      save)
        _octopius_process_save && `cd $WORKING_DIR`
      ;;
      restart)
      _octopius_restart
      ;;
      compact)
      _octopius_process_compactdisk 
      ;;
      --no-ansi)
      _octopius_show_help --no-ansi
      ;;
      *|help|-h|--help|--ansi)
      _octopius_show_help --ansi
      ;;
    esac
  else
    echo $fg[red] "Vagrant folder is not found. Please re-check, it must be located at ${OCTOBOX_VAGRANT_DIR}"
  fi
}
function _octopius_up()
{
  if [[ ! -z $1 ]]; then
    _octopius_vagrantfile_mydns_$1 ls -A $HOME | grep '.mydns_${1}' &> /dev/null;
    _octopius_process_up
  else
    echo "${fg[blue]}Connection parameter is missing. Auto-detect proxy connection..."
    _octopius_process_up_autodetect
  fi
}
function _octopius_restart()
{
  echo "${fg[blue]}Check current proxy connection...";
  _octopius_process_autodetect_config && _octopius_process_restart
}
function _octopius_process_up_autodetect()
{
  _octopius_process_autodetect_config && _octopius_process_up
}
function _octopius_process_ssh()
{
  echo "${fg[blue]}You're logging in now...${reset_color}\n" && vagrant ssh "$OCTOBOX_ID"
}
function _octopius_process_up()
{
  if _octopius_process_status "$OCTOBOX_ID"; then
    _octopius_process_ssh
  else
    echo "${fg[blue]}Start booting ${OCTOBOX_MACHINE}${fg[blue]}, please be patient..."
    vagrant reload "$OCTOBOX_ID" &> /dev/null
    echo "${OCTOBOX_MACHINE} ${fg[blue]}is ready to use."
    _octopius_process_ssh
  fi
}
function _octopius_process_down()
{
  if _octopius_process_status "$OCTOBOX_ID"; then
    echo "${fg[blue]}We are going to shutting down the ${OCTOBOX_MACHINE}${fg[blue]}..."
    vagrant halt "$OCTOBOX_ID" &> /dev/null
    echo "${OCTOBOX_MACHINE} ${fg[blue]}is already shutting down now. You are free to go!"
  fi
}
function _octopius_process_save()
{
  echo "${fg[blue]}We are going to suspending the ${OCTOBOX_MACHINE}${fg[blue]}..."
  vagrant suspend "$OCTOBOX_ID" &> /dev/null
  echo "${OCTOBOX_MACHINE} ${fg[blue]}is already saved now. You are free to go!"
}
function _octopius_process_restart()
{
  echo "${fg[blue]}We are going to restart and reload the ${OCTOBOX_MACHINE}${fg[blue]}..."
  vagrant reload "$OCTOBOX_ID" &> /dev/null
  echo "${OCTOBOX_MACHINE} ${fg[blue]}is already to use now."
  _octopius_process_ssh
}
function _octopius_process_autodetect_config()
{
  if [[ -f $HOME/.mydns_home ]]; then
    _octopius_vagrantfile_mydns_home
  elif [[ -f $HOME/.mydns_work ]]; then
    _octopius_vagrantfile_mydns_work
  elif [[ -f $HOME/.mydns_coffee ]]; then
    _octopius_vagrantfile_mydns_coffee
  else
    echo "${fg[red]}Unable to reach your connection. Execute mydns home|work|coffee and try again."
  fi
}
function _octopius_process_compactdisk()
{
  echo "${fg[red]}This function is under development ${OCTOBOX_MACHINE}"
  #local DISK=$HOME/VirtualBox\ VMs/octopius_dev_machine/cloned-disk1.vdi
  #$(VBoxManage modifyhd --compact $DISK) &>/dev/null
}
function _octopius_process_status()
{
  if [[ ! -z $1 ]]; then
    vagrant status "$1" | grep 'running' &>/dev/null
    if [[ $? -eq 0 ]]; then
      return 0
    else
      return 1
    fi
  fi
}
function _octopius_vagrantfile_mydns_home()
{
  ls -A $HOME | grep '.mydns_home' &>/dev/null
  if [[ $? -eq 0 ]]; then
    rsync $OCTOBOX_PLUGIN_DIR/files/vagrantfile/Vagrantfile.home Vagrantfile &>/dev/null
    echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}HOME ${fg[blue]}connection. (Public IP: ${fg[red]}192.168.1.253)"
  fi
}
function _octopius_vagrantfile_mydns_coffee()
{
  CURRENT_SSID=`airport -I | awk -F': ' '/ SSID/ {print $2}'`

  ls -A $HOME | grep '.mydns_coffee' &>/dev/null
  if [[ $? -eq 0 ]]; then
    if [[ $CURRENT_SSID == "Anhcafe" ]]; then
      rsync $OCTOBOX_PLUGIN_DIR/files/vagrantfile/Vagrantfile.coffee.anhcafe $OCTOBOX_VAGRANT_DIR/Vagrantfile &>/dev/null
      echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}COFFEE[Anhcafe] ${fg[blue]}connection. (Public IP: ${fg[red]}192.168.100.253)"
    elif [[ $CURRENT_SSID == "Highlands Coffee" ]]; then
      rsync $OCTOBOX_PLUGIN_DIR/files/vagrantfile/Vagrantfile.coffee.highlands $OCTOBOX_VAGRANT_DIR/Vagrantfile &>/dev/null
      echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}COFFEE[Highlands] ${fg[blue]}connection. (Public IP: ${fg[red]}10.10.10.253)"
    else
      rsync $OCTOBOX_PLUGIN_DIR/files/vagrantfile/Vagrantfile.coffee.highlands $OCTOBOX_VAGRANT_DIR/Vagrantfile &>/dev/null
      echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}COFFEE[Highlands] ${fg[blue]}connection. (Public IP: ${fg[red]}192.168.1.253)"
    fi
  fi
}
function _octopius_vagrantfile_mydns_work()
{
  CURRENT_SSID=`airport -I | awk -F': ' '/ SSID/ {print $2}'`
  BI_003="bi003"

  ls -A $HOME | grep '.mydns_work' &>/dev/null
  if [[ $? -eq 0 ]]; then
    if [[ $CURRENT_SSID == "bi003" ]]; then
      rsync $OCTOBOX_PLUGIN_DIR/files/vagrantfile/Vagrantfile.work.bi.003 $OCTOBOX_VAGRANT_DIR/Vagrantfile &>/dev/null
      echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}WORK[BI_003] ${fg[blue]}connection. (Public IP: ${fg[red]}192.168.0.253)"
    elif [[ $CURRENT_SSID == "bi001" ]]; then
      rsync $OCTOBOX_PLUGIN_DIR/files/vagrantfile/Vagrantfile.work.bi.001 $OCTOBOX_VAGRANT_DIR/Vagrantfile &>/dev/null
      echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}WORK[BI_001] ${fg[blue]}connection. (Public IP: ${fg[red]}10.0.1.253)"
    else
      rsync $OCTOBOX_PLUGIN_DIR/files/vagrantfile/Vagrantfile.work.bi.003 $OCTOBOX_VAGRANT_DIR/Vagrantfile &>/dev/null
      echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}WORK[BI_003] ${fg[blue]}connection. (Public 
      IP: ${fg[red]}192.168.0.253)"
    fi
  fi
}
function _octopius_show_help()
{
  case "$1" in
    --ansi)
      echo $fg[yellow] ""; dbox "OCTOPIUS DEV MACHINE MANAGER"

      echo

      echo "${fg[yellow]}Usage:"
      echo $reset_color "octopius [commands] [options]"

      echo

      echo "${fg[yellow]}Options:"
      echo $fg[green] "--help${reset_color}(-h)       Display this help message."
      echo $fg[green] "--quiet${reset_color}(-q)      Do not output any message."
      echo $fg[green] "--ansi${reset_color}           Force ANSI output."
      echo $fg[green] "--no-ansi${reset_color}        Disable ANSI output."

      echo

      echo "${fg[yellow]}Available commands:"
      echo $fg[green] "up${reset_color}               Start, provisioning and login to ${OCTOBOX_MACHINE_ANSI}."
      echo $fg[green] "ssh${reset_color}              Login to ${OCTOBOX_MACHINE_ANSI}."
      echo $fg[green] "down${reset_color}             Stops ${OCTOBOX_MACHINE_ANSI} and go to previous working dir."
      echo $fg[green] "save${reset_color}             Suspends ${OCTOBOX_MACHINE_ANSI} and go to previous working dir."
      echo $fg[green] "restart${reset_color}          Restart ${OCTOBOX_MACHINE_ANSI}, loads new config file."
      echo $fg[green] "compact${reset_color}          Compact virtual disk to save space."
    ;;
    --no-ansi)
      echo ""; dbox "OCTOPIUS DEV MACHINE MANAGER"

      echo

      echo "Usage:"
      echo " octopius [commands] [options]"

      echo

      echo "Options:"
      echo " --help${reset_color}(-h)       Display this help message."
      echo " --quiet${reset_color}(-q)      Do not output any message."
      echo " --ansi${reset_color}           Force ANSI output."
      echo " --no-ansi${reset_color}        Disable ANSI output."

      echo

      echo "Available commands:"
      echo " up ${reset_color}              Start, provisioning and login to ${OCTOBOX_MACHINE_ANSI}."
      echo " ssh${reset_color}              Login to ${OCTOBOX_MACHINE_ANSI}."
      echo " down${reset_color}             Stops ${OCTOBOX_MACHINE_ANSI} and go to previous working dir."
      echo " save${reset_color}             Suspends ${OCTOBOX_MACHINE_ANSI} and go to previous working dir."
      echo " restart${reset_color}          Restart ${OCTOBOX_MACHINE_ANSI}, loads new config file."
      echo " compact${reset_color}          Compact virtual disk to save space."
    ;;
  esac
}
