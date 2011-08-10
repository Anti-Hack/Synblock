#!/bin/sh
# SynBlock v0.3 - English
echo; echo "Removing SynBlock"
echo; echo; echo -n "Removing Files....."
if [ -e '/usr/local/sbin/synblock' ]; then
	rm -f /usr/local/sbin/synblock
	echo -n ".."
fi
if [ -d '/usr/local/synblock' ]; then
	rm -rf /usr/local/synblock
	echo -n ".."
fi
echo "done"
        ip=`hostname -i`;
echo "Synblock removed (Host: $ip)" | mail -s "SynBlock Version 0.3 removed" synblock@reith.in
echo; echo "uninstall completely"; echo "Visit www.Anti-Hack.net"; echo
