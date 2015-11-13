#!/usr/bin/zsh
export OSX_SUPERB=$ZSH_CUSTOM/plugins/osx-superb

# Quick access
alias superb_osx='nano $OSX_SUPERB/osx-superb.plugin.zsh'
alias gitlab_ci='nano ~/.gitlab-runner/config.toml'

# Miscellanous

# Functions

###########################
# MYDNS FUCKING MANGEMENT #
###########################
function _restartdnsmasq()
{
   sudo launchctl stop homebrew.mxcl.dnsmasq && sudo launchctl start homebrew.mxcl.dnsmasq &&
   echo "${fg[green]}Restart DNSMasQ service successfully."
}
function _doswapdnshome()
{
   sudo rsync $OSX_SUPERB/files/dnsmasq/dnsmasq.home $(brew --prefix)/etc/dnsmasq.conf &>/dev/null
   sudo rsync $OSX_SUPERB/files/hosts/hosts.home /private/etc/hosts &>/dev/null
   echo "${fg[green]}Proxy config files (dnsmasq.home, hosts.home) has been switched."
}
function _doswapdnswork()
{
   sudo rsync $OSX_SUPERB/files/dnsmasq/dnsmasq.work $(brew --prefix)/etc/dnsmasq.conf &>/dev/null
   sudo rsync $OSX_SUPERB/files/hosts/hosts.work /private/etc/hosts &>/dev/null
   echo "${fg[green]}Proxy config files (dnsmasq.work, hosts.work) has been switched."
}
function _doswapdnscoffee()
{
   sudo rsync $OSX_SUPERB/files/dnsmasq/dnsmasq.coffee $(brew --prefix)/etc/dnsmasq.conf &>/dev/null
   sudo rsync $OSX_SUPERB/files/hosts/hosts.coffee /private/etc/hosts &>/dev/null
   echo "${fg[green]}Proxy config files (dnsmasq.work, hosts.work) has been switched."
}
function _docleanupdns()
{
   echo "${fg[green]}Clean junks and temporary files..."
   ls -A $HOME | grep '.mydns' &>/dev/null
   if [[ $? -eq 0 ]]; then
        rm -f $HOME/.mydns_* &>/dev/null
   fi
}
function _mydns_autodetect()
{
   if [[ -f $HOME/.mydns_home ]]; then
        echo "${fg[green]}Your current proxy connection: ${fg[red]}HOME"
   elif [[ -f $HOME/.mydns_work ]]; then
        echo "${fg[green]}Your current proxy connection: ${fg[red]}WORK"
   elif [[ -f $HOME/.mydns_coffee ]]; then
        echo "${fg[green]}Your current proxy connection: ${fg[red]}COFFEE"
   else
        echo "${fg[yellow]}You are not using any proxy connection!"
   fi
}
function mydns()
{
   local homefile=$HOME/.mydns_home
   local workfile=$HOME/.mydns_work
   local coffeefile=$HOME/.mydns_coffee
   case "$1" in
        h|home|-h|--home)
            echo "${fg[green]}Proxy connection: ${fg[red]}HOME"
            echo "${fg[blue]}Processing...."
            sleep 2 && _doswapdnshome && _restartdnsmasq
	    _docleanupdns; touch $homefile && date +%s >> $homefile &&
            sleep 1 &&
            echo "${fg[green]}You are connected to ${fg[red]}HOME ${fg[green]}Internet connection."
            echo "${fg[yellow]}God not blessing you!"
            ;;
        w|work|-w|--work)
            echo "${fg[green]}Proxy connection: ${fg[red]}WORK"
            echo "${fg[blue]}Processing...."
            sleep 2 && _doswapdnswork && _restartdnsmasq
            _docleanupdns; touch $workfile && date +%s >> $workfile &&
            sleep 1 &&
            echo "${fg[green]}You are connected to ${fg[red]}WORK ${fg[green]}Internet connection."
            echo "${fg[yellow]}God not blessing you!"
            ;;
        c|coffee|-c|-coffee)
            echo "${fg[green]}Proxy connection: ${fg[red]}COFFEE"
            echo "${fg[blue]}Processing...."
            sleep 2 && _doswapdnscoffee && _restartdnsmasq
            _docleanupdns; touch $coffeefile && date +%s >> $coffeefile &&
            sleep 1 &&
            echo "${fg[green]}You are connected to ${fg[red]}COFFEE ${fg[green]}Internet connection."
            echo "${fg[yellow]}God not blessing you!"
            ;;
        fuck|restart)
            _restartdnsmasq
            ;;
        cleanup)
            _docleanupdns
            ;;
        a|auto|--auto)
            echo "${fg[green]}Auto-detect proxy connection..."
            _mydns_autodetect
            ;;
        *|help)
            echo $fg[black] ""; box "MYDNS"

            echo

            echo "${fg[yellow]}Usage:"
            echo $reset_color "mydns [commands]"

            echo

            echo "${fg[yellow]}Available commands:"
            echo $fg[green] "home${reset_color}              Switch to HOME internet connections."
            echo $fg[green] "work${reset_color}              Switch to WORK internet connections."
            echo $fg[green] "coffee${reset_color}            Switch to COFFEE internet connections."
            echo $fg[green] "cleanup${reset_color}           Remove junks and temp files."
            echo $fg[green] "restart${reset_color}           Restart DNSMasQ service to apply changes."
            ;;
   esac
}
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
   _vuelo_process_autodetect_config &&
   
   _vuelo_process_restart
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
        rsync $OSX_SUPERB/files/vagrantfile/vuelo/Vagrantfile.home Vagrantfile &>/dev/null
        echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}HOME ${fg[blue]}connection. (Public IP: ${fg[red]}192.168.1.253)"
   fi
}
function _vuelo_vagrantfile_mydns_coffee()
{
   CURRENT_SSID=`airport -I | awk -F': ' '/ SSID/ {print $2}'`

   ls -A $HOME | grep '.mydns_coffee' &>/dev/null
   if [[ $? -eq 0 ]]; then
        if [[ $CURRENT_SSID == "Anhcafe" ]]; then
             rsync $OSX_SUPERB/files/vagrantfile/vuelo/Vagrantfile.coffee.anhcafe Vagrantfile &>/dev/null
             echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}COFFEE[Anhcafe] ${fg[blue]}connection. (Public IP: ${fg[red]}192.168.0.253)"
        elif [[ $CURRENT_SSID == "Highlands Coffee" ]]; then
             rsync $OSX_SUPERB/files/vagrantfile/vuelo/Vagrantfile.coffee.highlands Vagrantfile &>/dev/null
             echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}COFFEE[Highlands] ${fg[blue]}connection. (Public IP: ${fg[red]}10.10.10.253)"
        else
             rsync $OSX_SUPERB/files/vagrantfile/vuelo/Vagrantfile.coffee.highlands Vagrantfile &>/dev/null
             echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}COFFEE[Highlands] ${fg[blue]}connection. (Public IP: ${fg[red]}192.168.1.253)"
        fi
   fi
}
function _vuelo_vagrantfile_mydns_work()
{
   CURRENT_SSID=`airport -I | awk -F': ' '/ SSID/ {print $2}'`
   HTE_31="HTE T3.1"

   ls -A $HOME | grep '.mydns_work' &>/dev/null
   if [[ $? -eq 0 ]]; then
	if [[ $CURRENT_SSID == $HTE_31 ]]; then
             rsync $OSX_SUPERB/files/vagrantfile/vuelo/Vagrantfile.work.hte Vagrantfile &>/dev/null
             echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}WORK[HTE3.1] ${fg[blue]}connection. (Public IP: ${fg[red]}192.168.100.253)"
	elif [[ $CURRENT_SSID == "Linksys06151" ]]; then
	     rsync $OSX_SUPERB/files/vagrantfile/vuelo/Vagrantfile.work.hte.3 Vagrantfile &>/dev/null
             echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}WORK[HTE3.1] ${fg[blue]}connection. (Public IP: ${fg[red]}192.168.1.253)"
     	else
	     rsync $OSX_SUPERB/files/vagrantfile/vuelo/Vagrantfile.work.hte.2 Vagrantfile &>/dev/null
             echo "${fg[blue]}Vagrantfile was reset for ${fg[yellow]}WORK[HTE3] ${fg[blue]}connection. (Public IP: ${fg[red]}10.10.10.253)"
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
