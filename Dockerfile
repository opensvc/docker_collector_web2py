FROM ubuntu:18.10
MAINTAINER admin@opensvc.com

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y patch uwsgi-plugin-python uwsgi python-mysqldb python-tornado python-yaml \
                       python-xmpp python-redis graphviz openssh-client git fping nodejs nodejs npm \
                       python-requests python-cryptography python-jwt python-ldap vim phantomjs \
                       xvfb python-whisper && \
    apt-get clean

ADD ar/web2py.tar.gz /opt
COPY /docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/
ONBUILD COPY /docker-entrypoint.d/* /docker-entrypoint.d/

WORKDIR /opt
RUN cp /opt/web2py/handlers/wsgihandler.py /opt/web2py/ && \
    mv /opt/web2py/applications/admin /tmp && \
    rm -rf /opt/web2py/applications/* && \
    chmod +x /docker-entrypoint.sh /docker-entrypoint.d/*

RUN npm install vm2 -g

ENTRYPOINT ["/docker-entrypoint.sh"]

