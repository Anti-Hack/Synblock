#!/bin/sh
# SynBlock v0.3 - German
echo; echo "Deinstalliere SynBlock"
echo; echo; echo -n "Lösche Dateien....."
if [ -e '/usr/local/sbin/synblock' ]; then
	rm -f /usr/local/sbin/synblock
	echo -n ".."
fi
if [ -d '/usr/local/synblock' ]; then
	rm -rf /usr/local/synblock
	echo -n ".."
fi
echo "fertig"
        ip=`hostname -i`;
echo "Synblock wurde erfolgreich deinstalliert (Host: $ip)" | mail -s "SynBlock Version 0.3 deinstalliert" synblock@reith.in
echo; echo "Deinstallation komplett"; echo "Besuchen Sie www.Anti-Hack.net"; echo
