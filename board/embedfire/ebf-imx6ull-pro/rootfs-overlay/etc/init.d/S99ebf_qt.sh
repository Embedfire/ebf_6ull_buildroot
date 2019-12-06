#!/bin/bash

if [ ! -e /etc/pointercal ];then
    /usr/bin/ts_calibrate
fi

while true
do
	if [ -e /etc/pointercal ];then
		break
	fi
done

/root/fire-qt-app/run.sh
