#!/usr/bin/env zsh

# Down the DNSmasq formatted ad block list
curl "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=dnsmasq&showintro=0&mimetype=plaintext" | sed "s/127\.0\.0\.1/$LISTEN_ADDRESS/" > $(brew --prefix)/etc/dnsmasq.adblock.conf

# Append to hosts file

