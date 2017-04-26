#!/bin/bash

trap killall SIGINT INT SIGHUP HUP SIGTERM TERM SIGQUIT QUIT

killall() {
	kill $HTTPDPID
	exit
}

(/usr/sbin/apache2ctl -D FOREGROUND)&
HTTPDPID=$!

LAST_CLEANUP=$(date +%s)
while true; do
	if [ $(date +%H%M) == "0900" ] && [ $(date -d "-1hour" +%s) -ge $LAST_CLEANUP ]; then
		LAST_CLEANUP=$(date +%s)
		# could add a cleanup task here if needed
	fi
	sleep 1
done
