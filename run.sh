#!/bin/bash
set -ex

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

    if [ ! -z "${path/\/}" ]; then
        export MYSQL_DATABASE=${path/\/}
    fi
fi

if [ ! -z "${INITDB}" ]; then
    echo "${INITDB}" > /docker-entrypoint-initdb.d/init.sql
fi

if [ ! -z "${LOG_OUTPUT}" ]; then
    echo "log_output=${LOG_OUTPUT}" >> /etc/mysql/conf.d/custom.cnf
fi

if [ ! -z "${GENERAL_LOG}" ]; then
    echo "general_log=${GENERAL_LOG}" >> /etc/mysql/conf.d/custom.cnf
fi

if [ ! -z "${GENERAL_LOG_FILE}" ]; then
    echo "general_log_file=${GENERAL_LOG_FILE}" >> /etc/mysql/conf.d/custom.cnf
fi

if [ ! -z "${SLOW_QUERY_LOG}" ]; then
    echo "slow_query_log=${SLOW_QUERY_LOG}" >> /etc/mysql/conf.d/custom.cnf
fi

if [ ! -z "${SLOW_QUERY_LOG_FILE}" ]; then
    echo "slow_query_log_file=${SLOW_QUERY_LOG_FILE}" >> /etc/mysql/conf.d/custom.cnf
fi

if [ ! -z "${LONG_QUERY_TIME}" ]; then
    echo "long_query_time=${LONG_QUERY_TIME}" >> /etc/mysql/conf.d/custom.cnf
fi

if [ ! -z "${CONFIGURATION}" ]; then
    echo "${CONFIGURATION}" >> /etc/mysql/conf.d/custom.cnf
fi

/entrypoint.sh "$@" --console
