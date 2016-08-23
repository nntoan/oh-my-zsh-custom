#!/usr/bin/env zsh

# Show progress while file is copying
# Rsync options are:
#  -a - archive mode; equals -rlptgoD (no -H,-A,-X)
#  -z - compress file data during the transfer
#  -u - skip files that are newer on the receiver
#  -p - preserve permissions
#  -o - preserve owner
#  -g - preserve group
#  -h - output in human-readable format
#  --progress - display progress
#  -b - instead of just overwriting an existing file, save the original
#  --backup-dir=/tmp/rsync - move backup copies to "/tmp/rsync"
#  -e /dev/null - only work on local files
#  -- - everything after this is an argument, even if it looks like an option

local RSYNC_CLI=/usr/bin/rsync
local RSYNC_BREW_CLI=/usr/local/bin/rsync

alias rsync-copy="$RSYNC_CLI -avz --progress -h"
alias rsync-move="$RSYNC_CLI -avz --progress -h --remove-source-files"
alias rsync-update="$RSYNC_CLI -avzu --progress -h"
alias rsync-synchronize="$RSYNC_CLI -avzu --delete --progress -h"
alias rsync-backup="$RSYNC_CLI -azhb --backup-dir=/tmp/rsync -e /dev/null --progress --"
alias rsync-fuck="$RSYNC_BREW_CLI -aHAXxv --numeric-ids --delete --progress -e \"ssh -T -c arcfour -o Compression=no -x\""
