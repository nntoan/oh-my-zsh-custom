#!/usr/bin/env zsh
local SUPERB_ALIAS=$ZSH_CUSTOM/plugins/superb-aliases
local THIRD_PARTY=$ZSH_CUSTOM/tools/3rd-party

# Advanced Aliases.
# Use with caution
#

# ls, the common ones I use a lot shortened for rapid fire usage
alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='ls -lAFh'   #same with la
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'


alias zshrc='nano $HOME/.zshrc' #Quick access to the ~/.zshrc file
alias nanorc='nano $HOME/.nanorc' #Quick access to ~/.nanorc file
alias vimrc='nano $HOME/.vimrc'	#Quick access to ~/.vimrc file
alias superb='nano $SUPERB_ALIAS/superb-aliases.plugin.zsh' #Quick access to ~/.superb-aliases.plugin.zsh
alias nanoins='cp -r $THIRD_PARTY/nano/* $HOME/.nano/; cat $THIRD_PARTY/nanorc >> $HOME/.nanorc' #Quick install nano
alias nvimins='mkdir -p $HOME/.config; cp -r $THIRD_PARTY/nvim $HOME/.config/; vi +PlugInstall +qall' #Quick install nvim

alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '
alias pgrep="grep '[0-9]\{3\}-[0-9]\{4\}' '$1'"

alias t='tail -f'

# Command line head / tail shortcuts
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g M="| most"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
alias -g P="2>&1| pygmentize -l pytb"

alias dud='du -d 1 -h'
alias duf='du -sh *'
alias fd='find . -type d -name'
alias ff='find . -type f -name'

alias h='history | grep $1'
alias hgrep="fc -El 0 | grep"
alias help='man'
alias p='ps -f'
alias sortnr='sort -n -r'
alias unexport='unset'
alias j='jobs -l'
alias k='kill'
alias last='last -a'

alias whereami=display_info

#alias nano='nano'
alias wget='wget -c'
alias cls='clear'
alias contents='/bin/tar -tzf'

alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'
#alias rsync='rsync -avP'

# app-specificed
alias biggest='BLOCKSIZE=1048576; du -x | sort -nr | head -10'
alias boothistory='for wtmp in `dir -t /var/log/wtmp*`; do last reboot -f $wtmp; done | less'
alias charcount='wc -c $1'
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'
alias df='df -h'
alias directorydiskusage='du -s -k -c * | sort -rn'
alias diskwho='sudo iotop'
alias dmidecode='sudo dmidecode --type 17 | more'
alias ducks='ls -A | grep -v -e '\''^\.\.$'\'' |xargs -i du -ks {} |sort -rn |head -16 | awk '\''{print $2}'\'' | xargs -i du -hs {}'
#alias du='du -h --max-depth=1'
alias dush='du -sm *|sort -n|tail'
alias hiddenpnps='unhide (proc|sys|brute)'
alias hogc='ps -e -o %cpu,pid,ppid,user,cmd | sort -nr | head'
alias hogm='ps -e -o %mem,pid,ppid,user,cmd | sort -nr | head'
alias wordcount='wc -w $1'
alias topforever='top -l 0 -s 10 -o cpu -n 15'
alias osver='cat /etc/lsb-release'
alias osversion='sudo apt-show-versions'
alias exportkey='sudo apt-key export'
alias ffind='sudo find / -name $1'
alias processbycpuusage="ps -e -o pcpu,cpu,nice,state,cputime,args --sort pcpu | sed '/^ 0.0 /d'"
alias processbymemusage='ps -e -o rss=,args= | sort -b -k1,1n | pr -TW$COLUMNS'
alias processtree='ps -e -o pid,args --forest'
alias pss='ps -ef | grep $1'
alias sizeof='du -sh'
alias space='df -h'

# date & time
alias bdate="date '+%a, %b %d %Y %T %Z'"
alias cal='cal -3'
alias da='date "+%Y-%m-%d %A    %T %Z"'
alias dateh='date --help|sed "/^ *%a/,/^ *%Z/!d;y/_/!/;s/^ *%\([:a-z]\+\) \+/\1_/gI;s/%/#/g;s/^\([a-y]\|[z:]\+\)_/%%\1_%\1_/I"|while read L;do date "+${L}"|sed y/!#/%%/;done|column -ts_'
alias daysleft='echo "There are $(($(date +%j -d"Dec 31, $(date +%Y)")-$(date +%j))) left in year $(date +%Y)."'
alias epochtime='date +%s'
alias mytime='date +%H:%M:%S'
alias ntpdate='sudo ntpdate ntp.ubuntu.com pool.ntp.org'
alias oclock='read -A<<<".*.**..*....*** 8 9 5 10 6 0 2 11 7 4";for C in `date +"%H%M"|fold -w1`;do echo "${A:${A[C+1]}:4}";done'
alias onthisday='grep -h -d skip `date +%m/%d` /usr/share/calendar/*'
alias secconvert='date -d@1234567890'
alias stamp='date "+%Y%m%d%a%H%M"'
alias timestamp='date "+%Y%m%dT%H%M%S"'
alias today='date +"%A, %B %-d, %Y"'
alias weeknum='date +%V'

# miscellanous
alias killall='killall -u $USER -v'
alias less='less -Mw'
alias sdiff='/usr/bin/sdiff --expand-tabs --ignore-all-space --strip-trailing-cr --width=160'
alias updatedb='sudo updatedb'
alias updatefonts='sudo fc-cache -vf'

# network & internet
alias estab='ss -p | grep STA'
alias hdinfo='hdparm -i[I] /dev/sda'
alias hostip='wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1'
alias hostname_lookup='lookupd -d'
alias http_trace='pkt_trace port 80'
alias iftop='sudo iftop -i eth0'
alias listen='sudo netstat -pnutl'
alias lsock='sudo /usr/sbin/lsof -i -P'
alias memrel='free && sync && echo 3 > /proc/sys/vm/drop_caches && free'
alias nethogs='sudo nethogs eth0'
alias netl='sudo nmap -sT -O localhost'
alias networkdump='sudo tcpdump not port 22'
alias nsl='netstat -f inet | grep -v CLOSE_WAIT | cut -c-6,21-94 | tail +2'
alias ns='netstat -alnp --protocol=inet | grep -v CLOSE_WAIT | cut -c-6,21-94 | tail +2'
alias openports='sudo netstat -nape --inet'
alias pkt_trace='sudo tcpflow -i `active_net_iface` -c'
alias ports='lsof -i -n -P'
alias portstats='sudo netstat -s'
alias ramvalue='sudo dd if=/dev/mem | cat | strings'
alias tcpstats='sudo netstat -st'
alias tcp_='sudo netstat -atp'
alias tcp_trace='pkt_trace tcp'
alias topsites='curl -s -O http://s3.amazonaws.com/alexa-static/top-1m.csv.zip ; unzip -q -o top-1m.csv.zip top-1m.csv ; head -1000 top-1m.csv | cut -d, -f2 | cut -d/ -f1 > topsites.txt'
alias udpstats='sudo netstat -su'
alias udp='sudo netstat -aup'
alias udp_trace='pkt_trace udp'
alias website_dl='wget --random-wait -r -p -e robots=off -U mozilla "$1"'
alias website_images='wget -r -l1 --no-parent -nH -nd -P/tmp -A".gif,.jpg" "$1"'
alias whois='whois -H'
alias wwwmirror2='wget -k -r -l ${2} ${1}' # wwwmirror2 [level] [site]
alias wwwmirror='wget -ErkK -np ${1}'

# permissions
alias 000='chmod 000'
alias 640='chmod 640'
alias 660='chmod 660'
alias 644='chmod 644'
alias 770='chmod 770'
alias 755='chmod 755'
alias 775='chmod 775'
alias mx='chmod u+x'
alias perm='stat --printf "%a %n \n "'
alias restoremod='chgrp users -R .;chmod u=rwX,g=rX,o=rX -R .;chown $(pwd |cut -d / -f 3) -R .'

# Make zsh know about hosts already accessed by SSH
#zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

#####################################
############# FUNCTIONS #############
#####################################

# Max a box of '#' around given string
function dbox() { t="$1xxxx";c=${2:-#}; echo ${t//?/$c}; echo "$c $1 $c"; echo ${t//?/$c}; }

# Find your current IP over Internet
function myip() { lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | awk '{ print $4 }' | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' }

# Shows network information for your system
function netinfo() {
  echo "--------------- Network Information ---------------"
  /sbin/ifconfig | awk /'inet addr/ {print $2}'
  /sbin/ifconfig | awk /'Bcast/ {print $3}'
  /sbin/ifconfig | awk /'inet addr/ {print $4}'
  /sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
  myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
  echo "${myip}"
  echo "---------------------------------------------------"
}

# Find & Chmod 755 for directories and 644 for files
function batch_chmod() { env /bin/zsh $ZSH_CUSTOM/tools/batch_chmod.zsh }

# Fix Scaleway servers
function scaleway_fixer() {
  # /etc/default/ufw
  #perl -i -pe's/DEFAULT_INPUT_POLICY="DROP"/DEFAULT_INPUT_POLICY="ACCEPT"/g' /etc/default/ufw

  # /etc/ufw/after.rules
  tr '\n' '_' < sed '28s/$/_# fix scaleway NBD stupidity_-A ufw-reject-input -j DROP_/g' after.rules
}

# Wipe all mosh-server sessions except current session
function wipe_mosh() { kill $(ps --no-headers --sort=start_time -C mosh-server -o pid | head -n -1) }

# Fix utf8mb4_0900_ai_ci collation issue
function mysql57fix() {
  local filename="$1"
  gunzip < "$filename" | sed -e 's/utf8mb4_0900_ai_ci/utf8_general_ci/g' | gzip -c > temp.gz &&
  gunzip < temp.gz | sed -e 's/CHARSET=utf8mb4/CHARSET=utf8/g' | gzip -c > temp2.gz
  \/bin/mv temp2.gz "$filename" 2>/dev/null
  /bin/rm -f temp.gz 2>/dev/null
}
