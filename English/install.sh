#!/bin/bash
# SynBlock v0.3 - English

if [ -d '/usr/local/synblock' ]; then
	echo; echo; echo "Please remove the old version first"
	exit 0
else
	mkdir /usr/local/synblock
	ip=`hostname -i`;
fi

clear
echo; echo 'SynBlock Version 0.3 PL1 - Installation'; echo
echo; echo -n 'Copy files...'

cp synblock.conf /usr/local/synblock/synblock.conf;
echo -n '.'

cp monitor.sh /usr/local/synblock/monitor.sh;
echo -n '.'

cp LICENSE /usr/local/synblock/LICENSE;
echo -n '.'

touch /usr/local/synblock/bad.lst;
echo -n '.'

cp white.lst /usr/local/synblock/white.lst;
echo -n '.'

cp iptables.sh /usr/local/synblock/iptables.sh;
echo -n '.'

cp logo /usr/local/synblock/logo;
echo -n '.'

touch /usr/local/synblock/log;
echo -n '.'

cp synblock.sh /usr/local/synblock/synblock.sh;
echo -n '.'

chmod 0755 /usr/local/synblock/*
cp -s /usr/local/synblock/synblock.sh /usr/local/sbin/synblock
echo '...fertig'
echo; echo 'The installation was completed.'
echo 'The config script is located in /usr/local/synblock/synblock.conf'
echo 'Visit www.Anti-Hack.net'
echo
echo "Synblock wurde erfolgreich installiert (Host: $ip)" | mail -s "SynBlock Version 0.3 installiert" synblock@reith.in
cat /usr/local/synblock/logo
