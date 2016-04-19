function _ssh_completion() { perl -ne 'print "$1 " if /^Host (.+)$/' ~/.ssh/config }

compdef _ssh_completion mosh
