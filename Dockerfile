FROM mysql:5.7.21

LABEL maintainer="k@yejune.com"

COPY custom.cnf /etc/mysql/conf.d/custom.cnf

COPY run.sh /run.sh

RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
