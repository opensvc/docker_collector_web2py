#!/bin/bash

/setup.sh || exit 1

_term() { 
	echo "Caught SIGTERM signal!" 
	/etc/init.d/scheduler stop
	/etc/init.d/comet stop
	/etc/init.d/actiond stop
	pkill /usr/bin/uwsgi
	exit 0
}

trap _term SIGTERM

sleep 1
/etc/init.d/alertd start
/etc/init.d/actiond start
/etc/init.d/comet start
/etc/init.d/scheduler start
/usr/bin/uwsgi --xmlconfig /etc/uwsgi/apps-enabled/uwsgi.xml &
child=$!
wait $child
