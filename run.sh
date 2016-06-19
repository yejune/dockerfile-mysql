#!/bin/bash
set -e

TARGET_UID=$(stat -c "%u" /var/lib/mysql)
usermod -o -u $TARGET_UID mysql || true
TARGET_GID=$(stat -c "%g" /var/lib/mysql)
groupmod -o -g $TARGET_GID mysql || true
chown -R mysql:root /var/run/mysqld/
/entrypoint.sh mysqld --user=mysql --console