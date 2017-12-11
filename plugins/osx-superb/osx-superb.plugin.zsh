#!/usr/bin/zsh
OSX_SUPERB=$ZSH_CUSTOM/plugins/osx-superb

# Quick access
alias superb_osx='nano $OSX_SUPERB/osx-superb.plugin.zsh'
alias gitlab_ci='nano ~/.gitlab-runner/config.toml'

# Miscellanous
#alias composer='php -n /usr/local/bin/composer'

# Functions

###########################
# MYDNS FUCKING MANGEMENT #
###########################
function _restartdnsmasq()
{
   local DAEMON="/Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist"
   sudo brew services restart dnsmasq && dscacheutil -flushcache
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
            echo $fg[yellow] ""; dbox "MYDNS"

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
