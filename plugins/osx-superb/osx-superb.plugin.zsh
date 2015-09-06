# Quick access
alias superb='vim ~/.oh-my-zsh-custom/plugins/superb-aliases/superb-aliases.plugin.zsh'
alias superb_osx='vim ~/.oh-my-zsh-custom/plugins/osx-superb/osx-superb.plugin.zsh'

# Docker
alias kaliboot='docker run -t -i kalilinux/kali-linux-docker /bin/bash'

# Miscellanous
alias zarp='cd ~/Documents/Projects/Git/GitHub/zarp && sudo python zarp.py'

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
}
#
function _doswapdnswork()
{
   sudo rsync $OSX_SUPERB/files/dnsmasq/dnsmasq.work $(brew --prefix)/etc/dnsmasq.conf
}
#
function mydns()
{
   case "$1" in
        home)
            echo $fg[green] "Switching dnsmasq configuration for $1 connection..."
            _doswapdnshome && _restartdnsmasq
            echo $fg[green] "Connected to Internet using dnsmasq.$1"
            ;;
        work)
            echo $fg[green] "Switching dnsmasq configuration for $1 connection..."
            _doswapdnswork && _restartdnsmasq
            echo $fg[green] "Connected to Internet using dnsmasq.$1"
            ;;
        restart)
            _restartdnsmasq
            ;;
        *)
            echo $fg[blue] "Usage: mydns [home|work|restart]\n"
            echo "home     -- Change /etc/dnsmasq.conf for home internet connection.\n"
            echo "work     -- Change /etc/dnsmasq.conf for work private network connection.\n"
            echo "restart  -- Restart homebrew dnsmasq in OSX.\n"
            ;;
   esac
}
#
function cwas_dev_up() {
   wd sites/c-forces 2> /dev/null

   if [[ $? -eq 0 ]]; then
       vagrant global-status | grep 'running' &> /dev/null
        if [[ $? -eq 0 ]]; then
            vagrant ssh
        else
	    echo "${fg[blue]}Start booting ${fg[green]}cwas-dev-machine${fg[blue]}, please be patient..."
            vagrant up &> /dev/null && echo "${fg[green]}cwas-dev-machine ${fg[blue]}is ready to use now.${reset_color}" && vagrant ssh
        fi
   else
       echo "Vagrant folder is not found. Please re-check, it have to be located at /Users/<username>/Sites/c-forces.dev"
   fi
}
#
function cwas_dev_down() {
   wd sites/c-forces 2> /dev/null

   if [[ $? -eq 0 ]]; then
       vagrant global-status | grep 'running' &> /dev/null
        if [[ $? -eq 0 ]]; then
	    echo "${fg[blue]}We are going to shutting down the ${fg[green]}cwas-dev-machine ${fg[blue]}..."
            vagrant halt &> /dev/null
	    echo "${fg[green}cwas-dev-machine ${fg[blue]}is already poweroff now. You are free to go!"
        fi
   else
       echo "Vagrant folder is not found. Please re-check, it have to be located at /Users/<username>/Sites/c-forces.dev"
   fi
}
