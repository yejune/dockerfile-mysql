FROM mysql:5.7

MAINTAINER yejune "kwon@yejune.com"

ADD run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]