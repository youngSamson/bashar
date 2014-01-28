#!/bin/bash
# by Daniel Callister - Jan27,2014
# dcallister@bluehost.com
#

# any input?
if [[ ! "$1" ]] ; then
        echo "Please enter a server name"
        exit
fi

#only one argument please
if [[ $# -ne 1 ]]
then
        echo "Please enter only one server at a time"
        exit
else value="$1"
fi

# sanitize input
if [[ $value =~ ^box[0-9]{2,3}$ ]];
        then host=$value".bluehost.com";
elif [[ $value =~ ^host[0-9]{2,3}$ ]];
        then host=$value".hostmonster.com";
elif [[ $value =~ ^just[0-9]{2,3}$ ]];
        then host=$value".justhost.com";
elif [[ $value =~ ^fast[0-9]{2,3}$ ]];
        then host=$value".fastdomain.com";
elif [[ $value =~ ^rsb[0-9]{2}$ ]];
        then host=$value".bluehost.com";
elif [[ $value =~ ^rsj[0-9]{2}$ ]];
        then host=$value".justhost.com";
elif [[ $value =~ ^v[0-9]{2}.vps$ ]];
        then host=$value".unifiedlayer.com";
elif [[ $value =~ ^d[0-9]{4,5}.dedi$ ]];
        then host=$value".unifiedlayer.com";
else echo "box not recognized, Usage: cleanup.sh box234. For dedi, use d####.dedi. For vps, use v##.vps. Thank you.";
exit
fi

mysql stats -e "delete from 24hr_history where box_name = '$host'"
mysql stats -e "delete from ack where box_name = '$host'"
mysql stats -e "delete from await where box_name = '$host'"
mysql stats -e "delete from current_data where box_name = '$host'"
mysql stats -e "delete from event where box_name = '$host'"
mysql stats -e "delete from fire_stat where box_name = '$host'"
mysql stats -e "delete from fire_stat_history where box_name = '$host'"
mysql stats -e "delete from fsh_0 where box_name = '$host'"
mysql stats -e "delete from fsh_1 where box_name = '$host'"
mysql stats -e "delete from metric where box_name = '$host'"
mysql stats -e "delete from mutebox where box_name = '$host'"
mysql stats -e "delete from mysql_commands where box = '$host'"
mysql stats -e "delete from mysql_commands_hist where box = '$host'"
mysql stats -e "delete from server where name = '$host'"
mysql stats -e "delete from stat_mem where box_name = '$host'"

check_success=mysql stats -e "select name from server where name = '$host'\G" | grep -i com |awk '{print $2}'
if [[ $check_success =~ $host ]]
        then echo "Sorry, it didn't work."
else echo "Server "$host " removed from stats."
fi
exit
