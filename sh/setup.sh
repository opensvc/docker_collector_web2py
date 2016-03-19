#!/bin/bash
#
# First run setup
#
[ -f /conf/env ] && . /conf/env

CUSTO_UID=${CUSTO_UID:-1000}
CUSTO_GID=${CUSTO_GID:-1000}
CUSTO_PWD=${CUSTO_PWD:-012d696520ca4a9db8b8d74510d6effb}
CUSTO_WS_PWD=${CUSTO_WS_PWD:-magix123}

# create user to match mapping ids
getent group $CUSTO_GID >/dev/null 2>&1 || groupadd -g $CUSTO_GID collector
getent passwd $CUSTO_UID >/dev/null 2>&1 || useradd -u $CUSTO_UID -g $CUSTO_GID collector

# setup web2py admin password
echo "password=\"$CUSTO_PWD\"" >/opt/web2py/parameters_443.py

# setup websocket server password
sed -i -e "s/PASSWORD/$CUSTO_WS_PWD/" /etc/init.d/comet

# install the admin web2py application in the mapping, if not already present
test -d /opt/web2py/applications/admin || {
	test -d /tmp/admin && mv /tmp/admin /opt/web2py/applications/
}

# setup uwsgi.xml
sed -i -e "s/__UID__/$CUSTO_UID/" /etc/uwsgi/apps-enabled/uwsgi.xml
sed -i -e "s/__GID__/$CUSTO_GID/" /etc/uwsgi/apps-enabled/uwsgi.xml

# install custom uwsgi.xml
[ -f /conf/uwsgi.xml ] && {
	rm -f /etc/uwsgi/apps-enabled/uwsgi.xml
	ln -s /conf/uwsgi.xml /etc/uwsgi/apps-enabled/uwsgi.xml
}

# import the collector ssh keys
mkdir -p /home/collector/.ssh

[ -f /conf/id_rsa.pub -a -f /conf/id_rsa ] && {
        cp /conf/id_rsa* /home/collector/.ssh/
}
[ -f /conf/id_dsa.pub -a -f /conf/id_dsa ] && {
        cp /conf/id_dsa* /home/collector/.ssh/
}

chown -R collector:collector /home/collector
touch /opt/web2py/web2py.log
chown -R collector:collector /opt/web2py
chmod 700 /home/collector/.ssh
chmod 600 /home/collector/.ssh/id_*

exit 0
