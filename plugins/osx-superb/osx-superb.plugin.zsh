#!/usr/bin/zsh
export OSX_SUPERB=$ZSH_CUSTOM/plugins/osx-superb

# Quick access
alias superb_osx='nano $OSX_SUPERB/osx-superb.plugin.zsh'
alias gitlab_ci='nano ~/.gitlab-runner/config.toml'

# Functions
function _restartdnsmasq()
{
   sudo launchctl stop homebrew.mxcl.dnsmasq && sudo launchctl start homebrew.mxcl.dnsmasq &&
   echo $fg[green] "Restart dnsmasq successfully..."
}
#
function _doswapdnshome()
{
   sudo rsync $OSX_SUPERB/files/dnsmasq/dnsmasq.home $(brew --prefix)/etc/dnsmasq.conf
   sudo rsync $OSX_SUPERB/files/hosts/hosts.home /private/etc/hosts
}
#
function _doswapdnswork()
{
   sudo rsync $OSX_SUPERB/files/dnsmasq/dnsmasq.work $(brew --prefix)/etc/dnsmasq.conf
   sudo rsync $OSX_SUPERB/files/hosts/hosts.work /private/etc/hosts
}
#
function mydns()
{
   case "$1" in
        home)
            echo $fg[green] "Switching dnsmasq configuration for $1 connection..."
            _doswapdnshome && _restartdnsmasq
	    touch $HOME/.mydns_home; rm -f $HOME/.mydns.work
            echo $fg[green] "Connected to Internet using dnsmasq.$1 & hosts.$1"
            ;;
        work)
            echo $fg[green] "Switching dnsmasq configuration for $1 connection..."
            _doswapdnswork && _restartdnsmasq
	    touch $HOME/.mydns_work; rm -f $HOME/.mydns_home
            echo $fg[green] "Connected to Internet using dnsmasq.$1 & hosts.$1"
            ;;
        restart)
            _restartdnsmasq
            ;;
        *)
            echo $fg[blue] "Usage: mydns [home|work|restart]\n"
            echo "home     -- Change /etc/dnsmasq.conf for home internet connection.\n"
            echo "work     -- Change /etc/dnsmasq.conf for work private network connection.\n"
            echo "restart  -- Restart DNSMasQ service in OSX.\n"
            ;;
   esac
}
#
function cwas_dev_up() {
   wd sites/c-forces 2> /dev/null

   if [[ $? -eq 0 ]]; then
        vagrant status | grep 'running' &> /dev/null
        if [[ $? -eq 0 ]]; then
	    echo "${fg[blue]}You're logging in now...${reset_color}" && vagrant ssh
        else
	    echo "${fg[blue]}Start booting ${fg[green]}cwas-dev-machine${fg[blue]}, please be patient..."
            vagrant up &> /dev/null && echo "${fg[green]}cwas-dev-machine ${fg[blue]}is ready to use. You're logging in now...${reset_color}" && vagrant ssh
        fi
   else
       echo "Vagrant folder is not found. Please re-check, it have to be located at /Users/<username>/Sites/c-forces.dev"
   fi
}
#
function cwas_dev_down() {
   wd sites/c-forces 2> /dev/null

   if [[ $? -eq 0 ]]; then
        vagrant status | grep 'running' &> /dev/null
        if [[ $? -eq 0 ]]; then
	    echo "${fg[blue]}We are going to shutting down the ${fg[green]}cwas-dev-machine${fg[blue]}..."
            vagrant halt &> /dev/null
	    echo "${fg[green]}cwas-dev-machine ${fg[blue]}is already poweroff now. You are free to go!"
        fi
   else
       echo "Vagrant folder is not found. Please re-check, it have to be located at /Users/<username>/Sites/c-forces.dev"
   fi
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
              _vuelo_process_up $2
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
	      _vuelo_process_restart
	   ;;
      esac
   else
      echo $fg[red] "Site folder is not found. Please re-check, it must be located at ${HOME}/Sites/vuelo.dev"
   fi
}
function _vuelo_process_up()
{
   if [[ ! -z $1 ]]; then
        _vuelo_vagrantfile_mydns_$1 ls -A $HOME | grep '.mydns_${1}' &> /dev/null
        vagrant status | grep 'running' &> /dev/null

        if [[ $? -eq 0 ]]; then
             echo "${fg[blue]}You're logging in now...${reset_color}" && vagrant ssh
        else
             echo "${fg[blue]}Start booting ${fg[green]}vuelo-dev-machine${fg[blue]}, please be patient..."
             vagrant up &> /dev/null && echo "${fg[green]}vuelo-dev-machine ${fg[blue]}is ready to use. You're logging in now...${reset_color}" && vagrant ssh
        fi
   else
	echo "${fg[blue]}Connection parameter is missing. Auto-detect the connection..."
	_vuelo_process_up_autodetect
   fi
}
function _vuelo_process_up_autodetect()
{
   wd sites/vuelo 2> /dev/null

   if [[ -f $HOME/.mydns_home ]]; then
        _vuelo_vagrantfile_mydns_home ls -A $HOME | grep '.mydns_home' &> /dev/null
        vagrant status | grep 'running' &> /dev/null

        if [[ $? -eq 0 ]]; then
             echo "${fg[blue]}You're logging in now...${reset_color}" && vagrant ssh
        else
             echo "${fg[blue]}Start booting ${fg[green]}vuelo-dev-machine${fg[blue]}, please be patient..."
             vagrant up &> /dev/null && echo "${fg[green]}vuelo-dev-machine ${fg[blue]}is ready to use. You're logging in now...${reset_color}" && vagrant ssh
        fi
    elif [[ -f $HOME/.mydns_work ]]; then
        _vuelo_vagrantfile_mydns_work ls -A $HOME | grep '.mydns_work' &> /dev/null
        vagrant status | grep 'running' &> /dev/null

        if [[ $? -eq 0 ]]; then
             echo "${fg[blue]}You're logging in now...${reset_color}" && vagrant ssh
        else
             echo "${fg[blue]}Start booting ${fg[green]}vuelo-dev-machine${fg[blue]}, please be patient..."
             vagrant up &> /dev/null && echo "${fg[green]}vuelo-dev-machine ${fg[blue]}is ready to use. You're logging in now...${reset_color}" && vagrant ssh
        fi
    else
        echo $fg[red] "Unable to reach your connection. Execute mydns home|work and try again."
    fi
}
function _vuelo_process_ssh()
{
   echo "${fg[blue]}You're logging in now...${reset_color}" && vagrant ssh
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
   vagrant status | grep 'running' &> /dev/null
   if [[ $? -eq 0 ]]; then
        echo "${fg[blue]}We are going to suspending the ${fg[green]}vuelo-dev-machine${fg[blue]}..."
        `vagrant suspend` &> /dev/null
        echo "${fg[green]}vuelo-dev-machine ${fg[blue]}is already saved now. You are free to go!"
   fi
}
function _vuelo_process_restart()
{
   vagrant status | grep 'running' &> /dev/null
   if [[ $? -eq 0 ]]; then
        echo "${fg[blue]}We are going to restart and reload the ${fg[green]}vuelo-dev-machine${fg[blue]}..."
        `vagrant reload` &> /dev/null
        echo "${fg[green]}vuelo-dev-machine ${fg[blue]}is already to use now. You are free to go!" &&
	_vuelo_process_ssh
   fi
}
function _vuelo_vagrantfile_mydns_home()
{
   if [[ $? -eq 0 ]]; then
        rsync $OSX_SUPERB/files/vagrantfile/vuelo/Vagrantfile.home Vagrantfile
   fi
}
function _vuelo_vagrantfile_mydns_work()
{
   if [[ $? -eq 0 ]]; then
        rsync $OSX_SUPERB/files/vagrantfile/vuelo/Vagrantfile.work Vagrantfile
   fi
}
