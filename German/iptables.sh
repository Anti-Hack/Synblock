#!/bin/sh
# SynBlock v0.3 - German
#Konfiguration laden
. /usr/local/synblock/synblock.conf
chain=synblock_rules;


if $IPT -L $chain  >/dev/null 2>&1
then
echo "  .--------------------------------.";
echo "  | Die Regeln existieren bereits! |";
echo "  '--------------------------------'";


else
#IPtables leeren u. Regeln erstellen

$IPT -P INPUT ACCEPT >/dev/null 2>&1
$IPT -P OUTPUT ACCEPT >/dev/null 2>&1
$IPT -P FORWARD DROP >/dev/null 2>&1
$IPT -F INPUT >/dev/null 2>&1
$IPT -F OUTPUT >/dev/null 2>&1
$IPT -F FORWARD >/dev/null 2>&1
$IPT -F -t mangle >/dev/null 2>&1
#$IPT -A INPUT -i lo -j ACCEPT >/dev/null 2>&1
#$IPT -A INPUT -d 127.0.0.0/8 -j REJECT >/dev/null 2>&1
$IPT -A INPUT -i eth0 -j ACCEPT >/dev/null 2>&1
$IPT -A INPUT -m state --state INVALID -j DROP >/dev/null 2>&1
$IPT -N $chain  >/dev/null 2>&1
$IPT -A $chain -m limit --limit 100/second --limit-burst 150 -j RETURN >/dev/null 2>&1
$IPT -A $chain -j LOG --log-prefix "SYN-Flood: " >/dev/null 2>&1
$IPT -A $chain -j DROP >/dev/null 2>&1
#Fragwuerdige Pakete verwerfen
$IPT -A $chain -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP >/dev/null 2>&1
$IPT -A $chain -p tcp --tcp-flags ALL ALL -j DROP >/dev/null 2>&1
$IPT -A $chain -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP >/dev/null 2>&1
$IPT -A $chain -p tcp --tcp-flags ALL NONE -j DROP >/dev/null 2>&1
$IPT -A $chain -p tcp --tcp-flags SYN,RST SYN,RST -j DROP >/dev/null 2>&1
$IPT -A $chain -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP >/dev/null 2>&1
echo "  .-----------------------------.";
echo "  | Die Regeln wurden angelegt! |";
echo "  '-----------------------------'";
fi
