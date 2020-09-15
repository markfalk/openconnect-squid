#!/bin/sh
if [ x$LOG_STDOUT == 'xtrue' ]
then
  chmod a+w /dev /dev/stdout /dev/stderr 
  echo "logfile_rotate 0" >> /etc/squid/squid.conf
  echo "cache_log stdio:/dev/stderr" >> /etc/squid/squid.conf
  echo "access_log stdio:/dev/stderr" >> /etc/squid/squid.conf
  echo "cache_store_log stdio:/dev/stderr" >> /etc/squid/squid.conf
fi

if [ x$DEBUG == 'xtrue' ]
then
   sleep infinity
   exit 0
fi

openconnect -b $ANYCONNECT_SERVER --timestamp

KAU=$ANYCONNECT_SERVER
KAT=300

if [ x$KEEP_ALIVE_URL != 'x' ]
then
   KAU=$KEEP_ALIVE_URL
fi

if [ x$KEEP_ALIVE_TIMEOUT != 'x' ]
then
   KAT=$KEEP_ALIVE_TIMEOUT
fi

while true
do
   sleep $KAT
   curl -x localhost:3128 -s -I -o /dev/null $KAU
done &

squid -N
