#!/usr/bin/zsh
local VUELOBOX_PLUGIN_DIR=$ZSH_CUSTOM/plugins/vuelobox_manager

#####################
# VUELO BOX MANAGER #
#####################
function vuelo()
{
  WORKING_DIR=$PWD
  wd sites/vuelo 2> /dev/null

  if [[ $? -eq 0 ]]; then
    case "$1" in
      up)
        _vuelo_up $2
      ;;
      ssh)
        _vuelo_process_ssh
      ;;
      down)
        _vuelo_process_down && `cd $WORKING_DIR`
      ;;
      save)
        _vuelo_process_save && `cd $WORKING_DIR`
      ;;
      restart)
      _vuelo_restart
      ;;
      compact)
      _vuelo_process_compactdisk && _vuelo_up
      ;;
      --no-ansi)
      _vuelo_show_help --no-ansi
      ;;
      *|help|-h|--help|--ansi)
      _vuelo_show_help --ansi
      ;;
    esac
  else
    echo $fg[red] "Vagrant folder is not found. Please re-check, it must be located at ${HOME}/Sites/DevMachines/vuelo.dev"
  fi
}
function _vuelo_up()
{
  if [[ ! -z $1 ]]; then
    _vuelo_vagrantfile_mydns_$1 ls -A $HOME | grep '.mydns_${1}' &> /dev/null;
    _vuelo_process_up
  else
    echo "${fg[blue]}Connection parameter is missing. Auto-detect proxy connection..."
    _vuelo_process_up_autodetect
  fi
}
function _vuelo_restart()
{
  echo "${fg[blue]}Check current proxy connection...";
  _vuelo_process_autodetect_config && _vuelo_process_restart
}
function _vuelo_process_up_autodetect()
{
  _vuelo_process_autodetect_config && _vuelo_process_up
}
function _vuelo_process_ssh()
{
  echo "${fg[blue]}You're logging in now...${reset_color}\n" && vagrant ssh
}
function _vuelo_process_up()
{
  vagrant status | grep 'running' &> /dev/null
  if [[ $? -eq 0 ]]; then
    _vuelo_process_ssh
  else
    echo "${fg[blue]}Start booting ${fg[green]}vuelo-dev-machine${fg[blue]}, please be patient..."
    vagrant up &> /dev/null
    echo "${fg[green]}vuelo-dev-machine ${fg[blue]}is ready to use."
    _vuelo_process_ssh
  fi
}
function _vuelo_process_down()
{
  vagrant status | grep 'running' &> /dev/null
  if [[ $? -eq 0 ]]; then
    echo "${fg[blue]}We are going to shutting down the ${fg[green]}vuelo-dev-machine${fg[blue]}..."
    vagrant halt &> /dev/null
    echo "${fg[green]}vuelo-dev-machine ${fg[blue]}is already poweroff now. You are free to go!"
  fi
}
function _vuelo_process_save()
{
  echo "${fg[blue]}We are going to suspending the ${fg[green]}vuelo-dev-machine${fg[blue]}..."
  vagrant suspend &> /dev/null
  echo "${fg[green]}vuelo-dev-machine ${fg[blue]}is already saved now. You are free to go!"
}
function _vuelo_process_restart()
{
  echo "${fg[blue]}We are going to restart and reload the ${fg[green]}vuelo-dev-machine${fg[blue]}..."
  vagrant reload &> /dev/null
  echo "${fg[green]}vuelo-dev-machine ${fg[blue]}is already to use now."
  _vuelo_process_ssh
}
function _vuelo_process_autodetect_config()
{
  if [[ -f $HOME/.mydns_home ]]; then
    _vuelo_vagrantfile_mydns_home
  elif [[ -f $HOME/.mydns_work ]]; then
    _vuelo_vagrantfile_mydns_work
  elif [[ -f $HOME/.mydns_coffee ]]; then
    _vuelo_vagrantfile_mydns_coffee
  else
    echo "${fg[red]}Unable to reach your connection. Execute mydns home|work|coffee and try again."
  fi
}
function _vuelo_process_compactdisk()
{
  $DISK=$HOME/VirtualBox\ VMs/vuelo_dev_machine/cloned-disk1.vdi
  VBoxManage modifyhd --compact ~/VirtualBox\ VMs/vuelo_dev_machine/cloned-disk1.vdi &>/dev/null
}
function _vuelo_process_status()
{
  vagrant status | grep 'running' &>/dev/null
  if [[ $? -eq 0 ]]; then
    echo "${fg[green]}vuelo-dev-machine${fg[blue]} is running..."
  else
    echo "${fg[green]}vuelo-dev-machine${fg[blue]} is not running..."
  fi
}
function _vuelo_vagrantfile_mydns_home()
{
  ls -A $HOME | grep '.mydns_home' &>/dev/null
  if [[ $? -eq 0 ]]; then
    rsync $VUELOBOX_PLUGIN_DIR/files/vagrantfile/vuelo/Vagrantfile.home Vagrantfile &>/dev/null
    echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}HOME ${fg[blue]}connection. (Public IP: ${fg[red]}192.168.1.253)"
  fi
}
function _vuelo_vagrantfile_mydns_coffee()
{
  CURRENT_SSID=`airport -I | awk -F': ' '/ SSID/ {print $2}'`

  ls -A $HOME | grep '.mydns_coffee' &>/dev/null
  if [[ $? -eq 0 ]]; then
    if [[ $CURRENT_SSID == "Anhcafe" ]]; then
      rsync $VUELOBOX_PLUGIN_DIR/files/vagrantfile/vuelo/Vagrantfile.coffee.anhcafe Vagrantfile &>/dev/null
      echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}COFFEE[Anhcafe] ${fg[blue]}connection. (Public IP: ${fg[red]}192.168.100.253)"
    elif [[ $CURRENT_SSID == "Highlands Coffee" ]]; then
      rsync $VUELOBOX_PLUGIN_DIR/files/vagrantfile/vuelo/Vagrantfile.coffee.highlands Vagrantfile &>/dev/null
      echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}COFFEE[Highlands] ${fg[blue]}connection. (Public IP: ${fg[red]}10.10.10.253)"
    else
      rsync $VUELOBOX_PLUGIN_DIR/files/vagrantfile/vuelo/Vagrantfile.coffee.highlands Vagrantfile &>/dev/null
      echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}COFFEE[Highlands] ${fg[blue]}connection. (Public IP: ${fg[red]}192.168.1.253)"
    fi
  fi
}
function _vuelo_vagrantfile_mydns_work()
{
  CURRENT_SSID=`airport -I | awk -F': ' '/ SSID/ {print $2}'`
  BI_003="bi003"

  ls -A $HOME | grep '.mydns_work' &>/dev/null
  if [[ $? -eq 0 ]]; then
    if [[ $CURRENT_SSID == "bi003" ]]; then
      rsync $VUELOBOX_PLUGIN_DIR/files/vagrantfile/vuelo/Vagrantfile.work.bi Vagrantfile &>/dev/null
      echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}WORK[BI_003] ${fg[blue]}connection. (Public IP: ${fg[red]}192.168.0.253)"
    elif [[ $CURRENT_SSID == "bi001" ]]; then
      rsync $VUELOBOX_PLUGIN_DIR/files/vagrantfile/vuelo/Vagrantfile.work.bi2 Vagrantfile &>/dev/null
      echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}WORK[BI_001] ${fg[blue]}connection. (Public IP: ${fg[red]}10.0.1.253)"
    else
      rsync $VUELOBOX_PLUGIN_DIR/files/vagrantfile/vuelo/Vagrantfile.work.bi3 Vagrantfile &>/dev/null
      echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}WORK[BI_XXX] ${fg[blue]}connection. (Public 
      IP: ${fg[red]}10.10.10.253)"
    fi
  fi
}
function _vuelo_show_help()
{
  case "$1" in
    --ansi)
      echo $fg[black] ""; box "VUELO DEV MACHINE MANAGER"

      echo

      echo "${fg[yellow]}Usage:"
      echo $reset_color "vuelo [commands] [options]"

      echo

      echo "${fg[yellow]}Options:"
      echo $fg[green] "--help${reset_color}(-h)       Display this help message."
      echo $fg[green] "--quiet${reset_color}(-q)      Do not output any message."
      echo $fg[green] "--ansi${reset_color}           Force ANSI output."
      echo $fg[green] "--no-ansi${reset_color}        Disable ANSI output."

      echo

      echo "${fg[yellow]}Available commands:"
      echo $fg[green] "up${reset_color}               Start, provisioning and login to vuelo-dev-machine."
      echo $fg[green] "ssh${reset_color}              Login to vuelo-dev-machine."
      echo $fg[green] "down${reset_color}             Stops vuelo-dev-machine and go to previous working dir."
      echo $fg[green] "save${reset_color}             Suspends vuelo-dev-machine and go to previous working dir."
      echo $fg[green] "restart${reset_color}          Restart vuelo-dev-machine, loads new config file."
      echo $fg[green] "compact${reset_color}          Compact virtual disk to save space."
    ;;
    --no-ansi)
      echo ""; box "VUELO DEV MACHINE MANAGER"

      echo

      echo "Usage:"
      echo " vuelo [commands] [options]"

      echo

      echo "Options:"
      echo " --help${reset_color}(-h)       Display this help message."
      echo " --quiet${reset_color}(-q)      Do not output any message."
      echo " --ansi${reset_color}           Force ANSI output."
      echo " --no-ansi${reset_color}        Disable ANSI output."

      echo

      echo "Available commands:"
      echo " up ${reset_color}              Start, provisioning and login to vuelo-dev-machine."
      echo " ssh${reset_color}              Login to vuelo-dev-machine."
      echo " down${reset_color}             Stops vuelo-dev-machine and go to previous working dir."
      echo " save${reset_color}             Suspends vuelo-dev-machine and go to previous working dir."
      echo " restart${reset_color}          Restart vuelo-dev-machine, loads new config file."
      echo " compact${reset_color}          Compact virtual disk to save space."
    ;;
  esac
}
