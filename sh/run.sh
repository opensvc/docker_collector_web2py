#!/bin/bash

sleep 1
/usr/bin/uwsgi --xmlconfig /etc/uwsgi/apps-enabled/uwsgi.xml &
/etc/init.d/alertd start
/etc/init.d/comet start
/etc/init.d/scheduler start

/bin/bash
