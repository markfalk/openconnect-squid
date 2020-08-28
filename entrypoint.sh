#!/bin/sh
if [ $DEBUG == 'true' ]
then
   sleep infinity
   exit 0
fi
openconnect -b $ANYCONNECT_SERVER --timestamp
sleep 4
squid
sleep infinity
