#!/bin/sh
#This is an SSH-D proxy with auto-reconnect on disconnect

i=0
while test 1==1
do
    remote_ssh=$1
    local_port=22

    exist=`ps aux | grep $remote_ssh | grep $local_port`
    echo $exist
    if test -n "$exist"
    then
        if test $i -eq 0
        then
            echo "I'm alive since $(date)"
        fi
        i=1
    else
        i=0
        echo "I died... God is bringing me back..."
        ssh $remote_ssh -f -N -D 0.0.0.0:$local_port
    fi
    sleep 1
done
