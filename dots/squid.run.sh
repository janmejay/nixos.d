#!/usr/bin/env bash

# set -x

d=$(dirname $0)

echo $d

if [ ! -d $d/cache ]; then
    if [ -e $d/conf/key.pem ]; then
        chmod 400 $d/conf/*.pem
    else
        echo "Copy cert.pem and key.pem to $d/conf"
        exit 1
    fi
    (cd $d && mkdir -p cache spool logs)
    exec $0 -z
fi

squid -YC -f $d/conf/squid.conf -N $*
