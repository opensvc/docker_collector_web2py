FROM ubuntu:16.10
MAINTAINER admin@opensvc.com

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y patch uwsgi-plugin-python uwsgi python-mysqldb python-tornado python-yaml \
                       python-xmpp python-redis graphviz openssh-client git fping nodejs nodejs npm \
                       python-requests python-cryptography python-jwt python-ldap vim phantomjs \
                       xvfb python-whisper && \
    apt-get clean

ADD ar/web2py.tar.gz /opt
ADD cf/uwsgi.xml /etc/uwsgi/apps-enabled/
ADD sh/scheduler sh/alertd sh/actiond sh/comet /etc/init.d/
ADD sh/setup.sh sh/run.sh /

WORKDIR /opt
RUN cp /opt/web2py/handlers/wsgihandler.py /opt/web2py/ && \
    mv /opt/web2py/applications/admin /tmp && \
    rm -rf /opt/web2py/applications/* && \
    chmod +x /etc/init.d/comet /etc/init.d/scheduler /etc/init.d/alertd /etc/init.d/actiond /setup.sh /run.sh

RUN npm install vm2 -g

ENTRYPOINT /run.sh

