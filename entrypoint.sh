#!/bin/sh
cp /tmp/squid.conf /etc/squid/squid.conf

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

# Check for any redirections to get the true endpoint
ANYCONNECT_SERVER_TRUE=`curl -Ls -o /dev/null -w %{url_effective} $ANYCONNECT_SERVER`

openconnect -b $ANYCONNECT_SERVER_TRUE --timestamp
# required for squid to receive updated DNS resolv.conf
sleep 4

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

ssh-keygen -A
ssh-keygen -q -f ~/.ssh/id_rsa -N ""
cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys

ed /etc/ssh/sshd_config << EOF > /dev/null
1
/AllowTcpForwarding
d
a
AllowTcpForwarding yes
.
1
/GatewayPorts
d
a
GatewayPorts yes
.
w
q
EOF

/usr/sbin/sshd
#passwd -u root
ssh -o StrictHostKeyChecking=no -fN -g -D 1080 localhost

squid -N

