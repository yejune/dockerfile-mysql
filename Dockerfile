FROM mysql:5.7.21

LABEL maintainer="k@yejune.com"

COPY charset.cnf /etc/mysql/conf.d/charset.cnf

COPY run.sh /run.sh

RUN usermod -u 1000 mysql && \
    echo "innodb_use_native_aio=0" >> /etc/mysql/conf.d/docker.cnf && \
    chmod +x /run.sh && \
    chown mysql /docker-entrypoint-initdb.d/

ENTRYPOINT ["/run.sh"]
