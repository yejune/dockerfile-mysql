#!/bin/bash
set -e

if [ ! -z "${MYSQL_URL}" ]; then

    proto="$(echo $MYSQL_URL | grep :// | sed -e's,^\(.*://\).*,\1,g')"
    url="$(echo ${MYSQL_URL/$proto/})"
    userpass="$(echo $url | grep @ | cut -d@ -f1)"
    user="$(echo $userpass | grep : | cut -d: -f1)"
    pass="$(echo $userpass | grep : | cut -d: -f2)"
    hostport="$(echo ${url/$userpass@/} | cut -d/ -f1)"
    host="$(echo $hostport | grep : | cut -d: -f1)"
    port="$(echo $hostport | grep : | cut -d: -f2)"
    path="$(echo $url | grep / | cut -d/ -f2-)"

    [ -z "${user}" ] && user="${userpass}"
    [ -z "${host}" ] && host="${hostport}"
    if [ -z "${port}" ]; then
        port="3306"
    fi

    export MYSQL_USER=${user}
    export MYSQL_PASSWORD=${pass}
    export MYSQL_DATABASE=${path/\/}
fi

if [ ! -z "${INITDB}" ]; then
    echo ${INITDB} > /docker-entrypoint-initdb.d/init.sql
fi

/entrypoint.sh "$@" --console
