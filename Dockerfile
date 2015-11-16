FROM ubuntu:15.10
MAINTAINER admin@opensvc.com

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y patch uwsgi-plugin-python uwsgi python-tornado python-yaml python-xmpp python-redis graphviz unzip openssh-client git && \
    apt-get clean

ADD ar/web2py_src.zip /tmp/web2py.zip
ADD cf/uwsgi.xml /etc/uwsgi/apps-enabled/
ADD sh/scheduler /etc/init.d/scheduler
ADD sh/alertd /etc/init.d/alertd
ADD sh/actiond /etc/init.d/actiond
ADD sh/comet /etc/init.d/comet
ADD sh/setup.sh /setup.sh
ADD sh/run.sh /run.sh

WORKDIR /opt
RUN unzip /tmp/web2py.zip && rm -f /tmp/web2py.zip && \
    mv web2py-master web2py && \
    cp /opt/web2py/handlers/wsgihandler.py /opt/web2py/ && \
    mv /opt/web2py/applications/admin /tmp && \
    rm -rf /opt/web2py/applications/examples && \
    rm -rf /opt/web2py/applications/welcome && \
    chmod +x /etc/init.d/comet /etc/init.d/scheduler /etc/init.d/alertd /etc/init.d/actiond /setup.sh /run.sh

CMD /setup.sh && /run.sh

