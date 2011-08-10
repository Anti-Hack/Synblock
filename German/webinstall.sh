#!/bin/bash
# SynBlock v0.3 - German

if [ -d '/usr/local/synblock' ]; then
	echo; echo; echo "Bitte entfernen Sie zuerst die alte Version"
	exit 0
else
	mkdir /usr/local/synblock
	ip=`hostname -i`;
fi

clear
echo; echo 'SynBlock Version 0.3 PL1 - Installation'; echo
echo; echo -n 'Downloade Quelldateien...'

wget -q -O /usr/local/synblock/synblock.conf http://www.Anti-Hack.net/scripts/synblock/synblock.conf
echo -n '.'

wget -q -O /usr/local/synblock/monitor.sh http://www.Anti-Hack.net/scripts/synblock/monitor.sh
echo -n '.'

wget -q -O /usr/local/synblock/LICENSE http://www.Anti-Hack.net/scripts/synblock/LICENSE
echo -n '.'

touch /usr/local/synblock/bad.lst

wget -q -O /usr/local/synblock/white.lst http://www.Anti-Hack.net/scripts/synblock/white.lst
echo -n '.'

wget -q -O /usr/local/synblock/iptables.sh http://www.Anti-Hack.net/scripts/synblock/iptables.sh
echo -n '.'

wget -q -O /usr/local/synblock/logo http://www.Anti-Hack.net/scripts/synblock/logo
echo -n '.'

touch /usr/local/synblock/log

wget -q -O /usr/local/synblock/synblock.sh http://www.Anti-Hack.net/scripts/synblock/synblock.sh

chmod 0755 /usr/local/synblock/*
cp -s /usr/local/synblock/synblock.sh /usr/local/sbin/synblock
echo '...fertig'
echo; echo 'Die Installation wurde abgeschlossen.'
echo 'Die Kofigurationsdatei befindet sich unter /usr/local/synblock/synblock.conf'
echo 'Besuchen Sie www.Anti-Hack.net'
echo
echo "Synblock wurde erfolgreich installiert (Host: $ip)" | mail -s "SynBlock Version 0.3 installiert" synblock@reith.in
cat /usr/local/synblock/logo
