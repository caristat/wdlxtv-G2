#!/bin/sh

while [ 1 ]; do
	cd /osd;
	/bin/dmaosd $1 $2 $3;
	sleep 3;
	reboot;
done

