#!/bin/bash
# SynBlock v0.3 - English
. /usr/local/synblock/synblock.conf
BAD_IP_LIST=`$TMP_FILE`

CHAIN="synblock_banned";

if /sbin/iptables -L $CHAIN &> /dev/null
then
  echo;
  echo "  .--------------------.";
  echo "  | Loading Monitor... |";
  echo "  '--------------------'";
else
  $IPT -N $CHAIN
  echo;
  echo IPtables-Chain $CHAIN created!
  echo;
  echo;
  echo "  .--------------------.";
  echo "  | Loading Monitor... |";
  echo "  '--------------------'";
fi




function autoban ()
{
unbanip()
{
UNBAN_SCRIPT=`mktemp /tmp/unban.XXXXXXXXXX`
    TMP_FILE=`mktemp /tmp/unban.XXXXXXXXXX`
    UNBAN_IP_LIST=`mktemp /tmp/unban.XXXXXXXXXX`

    echo '#!/bin/bash' > $UNBAN_SCRIPT
    echo "sleep $BAN_TIME" >> $UNBAN_SCRIPT
    if [ $APF_BAN -eq 1 ]; then
        while read line; do
            echo "$APF -d $line" >> $UNBAN_SCRIPT
            echo $line >> $UNBAN_IP_LIST
        done < $BANNED_IP_LIST
    else
        while read line; do
            echo "$IPT -D $CHAIN -s $line -j DROP" >> $UNBAN_SCRIPT
            echo $line >> $UNBAN_IP_LIST
        done < $BANNED_IP_LIST
    fi
    echo "grep -v --file=$UNBAN_IP_LIST $WHITELST > $TMP_FILE" >> $UNBAN_SCRIPT
    echo "mv $TMP_FILE $WHITELST" >> $UNBAN_SCRIPT
    echo "rm -f $UNBAN_SCRIPT" >> $UNBAN_SCRIPT
    echo "rm -f $UNBAN_IP_LIST" >> $UNBAN_SCRIPT
    echo "rm -f $TMP_FILE" >> $UNBAN_SCRIPT
    . $UNBAN_SCRIPT &
}


echo "The following IP addresses were blocked at `date` :" > $BANNED_IP_MAIL
echo >>    $BANNED_IP_MAIL
#BAD_IP_LIST=`$TMP_FILE`
netstat -ntu | grep SYN_RECV | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr > $BAD_IP_LIST
cat $BAD_IP_LIST
if [ $BAN -eq 1 ]; then
    IP_BAN_NOW=0
    while read line; do
        CURR_LINE_CONN=$(echo $line | cut -d" " -f1)
        CURR_LINE_IP=$(echo $line | cut -d" " -f2)
        if [ $CURR_LINE_CONN -lt $MAX_REQ ]; then
            break
        fi
        IGNORE_BAN=`grep -c $CURR_LINE_IP $WHITELST`
        if [ $IGNORE_BAN -ge 1 ]; then
            continue
        fi
        IP_BAN_NOW=1
        echo "$CURR_LINE_IP with $CURR_LINE_CONN SYN_RECV connections" >> $BANNED_IP_MAIL
        echo $CURR_LINE_IP >> $BANNED_IP_LIST
        echo $CURR_LINE_IP >> $WHITELST
	echo $CURR_LINE_IP >> $BADLST
        if [ $APF_BAN -eq 1 ]; then
            $APF -d $CURR_LINE_IP
        else
            $IPT -I $CHAIN -s $CURR_LINE_IP -j DROP
        fi
    done < $BAD_IP_LIST
    if [ $IP_BAN_NOW -eq 1 ]; then
        dt=`date`
                hn=`hostname`
        if [ $EMAIL_TO != "" ]; then
            cat $BANNED_IP_MAIL | mail -s "IP addresses were blocked at $DATUM" $EMAIL_TO
        fi
        unbanip
    fi
fi
}

while sleep $speed;
do
rm -f $TMP_PREFIX.*
clear;
echo;
echo "  .-+----------------+-."
echo "  | SynBlock - Monitor |"
echo "  '-+----------------+-'"
let ipcount=`iptables -L synblock_banned -n | wc -l`;
let abzug=2;
let summe=$ipcount-$abzug
echo;
echo "Synblock has already blocked $summe attacking IPs";
echo;
echo "|Incoming SYN-Connections|"
autoban
done;

