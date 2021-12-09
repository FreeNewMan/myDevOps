FROM centos:7

ENV ES_VER=7.15.2 \
    ES_USER=elauser


RUN adduser ${ES_USER}
USER 0
RUN yum install wget -y \
    && wget http://mirror.centos.org/centos/7/os/x86_64/Packages/perl-Digest-SHA-5.85-4.el7.x86_64.rpm \
	&& yum install perl-Digest-SHA-5.85-4.el7.x86_64.rpm -y  \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VER}-linux-x86_64.tar.gz \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ES_VER}-linux-x86_64.tar.gz.sha512 \
    && shasum -a 512 -c elasticsearch-${ES_VER}-linux-x86_64.tar.gz.sha512 \
    && tar -xzf elasticsearch-${ES_VER}-linux-x86_64.tar.gz  \
	&& rm perl-Digest-SHA-5.85-4.el7.x86_64.rpm \
	&& rm elasticsearch-${ES_VER}-linux-x86_64.tar.gz.sha512 \
	&& rm elasticsearch-${ES_VER}-linux-x86_64.tar.gz \
    && cd elasticsearch-${ES_VER}/  

COPY elasticsearch.yml /elasticsearch-${ES_VER}/config/ 

RUN chown -R ${ES_USER} /elasticsearch-${ES_VER}/ \
  && mkdir /var/lib/elasticsearch/ \
  && chown -R ${ES_USER} /var/lib/elasticsearch/ \
  && mkdir /mnt/backups/ \
  && mkdir /mnt/long_term_backups/ \
  && chown -R ${ES_USER} /mnt/backups/ \
  && chown -R ${ES_USER} /mnt/long_term_backups/
EXPOSE 9200

USER ${ES_USER}
CMD /elasticsearch-${ES_VER}/bin/elasticsearch