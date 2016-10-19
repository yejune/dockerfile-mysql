FROM mysql:5.7.11

MAINTAINER yejune "kwon@yejune.com"

ADD charset.cnf /etc/mysql/conf.d/charset.cnf
ADD run.sh /run.sh

RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
