#!/usr/bin/env bash

# set -x

d=$(dirname $0)

echo $d

if [ ! -d $d/cache ]; then
    (cd $d && mkdir -p cache spool logs)
    exec $0 -z
fi

squid -YC -f $d/conf/squid.conf -N $*
