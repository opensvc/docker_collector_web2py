FROM ubuntu:14.10
MAINTAINER admin@opensvc.com

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y uwsgi-plugin-python uwsgi python-tornado python-yaml python-xmpp python-redis graphviz unzip openssh-client git

ADD ar/web2py-7b2b8155f94361764f0ef6a36b3c179ff758b2fc.zip /tmp/web2py.zip
ADD cf/uwsgi.xml /etc/uwsgi/apps-enabled/
ADD sh/scheduler /etc/init.d/scheduler
ADD sh/alertd /etc/init.d/alertd
ADD sh/actiond /etc/init.d/actiond
ADD sh/comet /etc/init.d/comet
ADD sh/setup.sh /setup.sh
ADD sh/run.sh /run.sh

WORKDIR /opt
RUN unzip /tmp/web2py.zip && rm -f /tmp/web2py.zip
RUN mv web2py-master web2py
RUN cp /opt/web2py/handlers/wsgihandler.py /opt/web2py/
RUN mv /opt/web2py/applications/admin /tmp
RUN rm -rf /opt/web2py/applications/examples
RUN rm -rf /opt/web2py/applications/welcome

RUN chmod +x /etc/init.d/comet /etc/init.d/scheduler /etc/init.d/alertd /etc/init.d/actiond /setup.sh /run.sh

CMD /setup.sh && /run.sh

