FROM ubuntu:18.10

LABEL vendor="OpenSVC"
LABEL maintainer="admin@opensvc.com"
 
RUN sed -i 's|archive.ubuntu|old-releases.ubuntu|g' /etc/apt/sources.list && \
    sed -i '/security.ubuntu.com/d' /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends -y patch uwsgi-plugin-python uwsgi python-mysqldb python-tornado python-yaml \
                       python-xmpp python-redis graphviz openssh-client git fping nodejs nodejs npm \
                       python-requests python-cryptography python-jwt python-ldap vim phantomjs \
                       xvfb python-whisper python-pip curl && \
    apt-get clean

RUN python -m pip install --upgrade pip && pip install setuptools && pip install uwsgitop

RUN curl -L -o- https://github.com/web2py/web2py/archive/R-2.14.1.tar.gz | tar xzf - -C /opt && \
    mv /opt/web2py-R-2.14.1 /opt/web2py
RUN curl -L -o- https://github.com/web2py/pydal/archive/v19.04.tar.gz | tar xzf - -C /opt && \
    rmdir /opt/web2py/gluon/packages/dal && \
    mv /opt/pydal-19.04 /opt/web2py/gluon/packages/dal
COPY /docker-entrypoint.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/
ONBUILD COPY /docker-entrypoint.d/* /docker-entrypoint.d/

WORKDIR /opt
RUN cp /opt/web2py/handlers/wsgihandler.py /opt/web2py/ && \
    mv /opt/web2py/applications/admin /tmp && \
    rm -rf /opt/web2py/applications/* && \
    chown -R 1000:1000 /opt/web2py && \
    chmod +x /docker-entrypoint.sh /docker-entrypoint.d/*

RUN npm install vm2 -g

ENTRYPOINT ["/docker-entrypoint.sh"]

