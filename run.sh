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
        [ "${proto}" = "http://" ]  && port="80"
        [ "${proto}" = "https://" ] && port="443"
        [ "${proto}" = "mysql://" ] && port="3306"
        [ "${proto}" = "redis://" ] && port="6379"
    fi

    MYSQL_USER=${user}
    MYSQL_PASSWORD=${pass}
    MYSQL_DATABASE=${path/\/}
fi

-TARGET_UID=$(stat -c "%u" /var/lib/mysql)
-usermod -o -u $TARGET_UID mysql || true
-TARGET_GID=$(stat -c "%g" /var/lib/mysql)
-groupmod -o -g $TARGET_GID mysql || true
-chown -R mysql:root /var/run/mysqld/

/entrypoint.sh mysqld --user=mysql --console